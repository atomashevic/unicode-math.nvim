local M = {}

local config = {
    renderer = "unicode",
    update_delay = 500,
    auto_render = true,
    filetypes = {"markdown"},
}

local backends = {}
local augroup_id = nil

function M.setup(opts)
    config = vim.tbl_deep_extend("force", config, opts or {})
    
    -- Load backends
    backends.unicode = require('unicode-math.backends.unicode')
    backends.unicode.setup(config)
    
    -- Load KaTeX backend if specified
    if config.renderer == "katex" then
        local ok, katex = pcall(require, 'unicode-math.backends.katex')
        if ok then
            backends.katex = katex
            backends.katex.setup(config)
        else
            vim.notify("KaTeX backend not available, falling back to Unicode", vim.log.levels.WARN)
            config.renderer = "unicode"
        end
    end
    
    -- Set up live rendering if enabled
    if config.auto_render then
        M.setup_live_rendering()
    end
    
    -- Set up user commands
    M.setup_commands()
end

function M.setup_live_rendering()
    if augroup_id then
        vim.api.nvim_del_augroup_by_id(augroup_id)
    end
    
    augroup_id = vim.api.nvim_create_augroup('Unicodemath', { clear = true })
    
    local patterns = {}
    if type(config.filetypes) == "table" then
        for _, ft in ipairs(config.filetypes) do
            table.insert(patterns, '*.' .. ft)
        end
    else
        table.insert(patterns, '*.' .. config.filetypes)
    end
    
    vim.api.nvim_create_autocmd({'TextChanged', 'TextChangedI'}, {
        group = augroup_id,
        pattern = patterns,
        callback = function()
            if config.update_delay > 0 then
                vim.defer_fn(M.update_math_preview, config.update_delay)
            else
                M.update_math_preview()
            end
        end,
    })
end

function M.setup_commands()
    vim.api.nvim_create_user_command('UnicodeRenderBuffer', function()
        M.render_buffer()
    end, {
        desc = 'Render all math expressions in current buffer to Unicode'
    })
    
    vim.api.nvim_create_user_command('UnicodeRenderLine', function()
        M.render_current_line()
    end, {
        desc = 'Render math expressions in current line to Unicode'
    })
    
    vim.api.nvim_create_user_command('UnicodeToggleAuto', function()
        M.toggle_auto_render()
    end, {
        desc = 'Toggle automatic math rendering'
    })
end

function M.update_math_preview()
    local bufnr = vim.api.nvim_get_current_buf()
    local filetype = vim.bo[bufnr].filetype
    
    -- Check if current filetype is supported
    if not vim.tbl_contains(config.filetypes, filetype) then
        return
    end
    
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local converted_lines = {}
    local any_changes = false
    
    for i, line in ipairs(lines) do
        local new_line = M.process_line(line)
        converted_lines[i] = new_line
        if new_line ~= line then
            any_changes = true
        end
    end
    
    if any_changes then
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, converted_lines)
        vim.notify("Math expressions rendered!", vim.log.levels.INFO)
    end
end

function M.process_line(line)
    local new_line = line
    
    -- Find and replace display math first: $$...$$
    new_line = new_line:gsub('%$%$([^%$]+)%$%$', function(math)
        if math and math ~= "" then
            return M.render(math, true)
        end
        return '$$' .. math .. '$$'
    end)
    
    -- Find and replace inline math: $...$
    new_line = new_line:gsub('%$([^%$]+)%$', function(math)
        if math and math ~= "" then
            return M.render(math)
        end
        return '$' .. math .. '$'
    end)
    
    return new_line
end

function M.render(expression, display_mode)
    local backend = backends[config.renderer] or backends.unicode
    return backend.render(expression, display_mode)
end

function M.render_buffer()
    local bufnr = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local modified = false
    
    for i, line in ipairs(lines) do
        local new_line = M.process_line(line)
        if new_line ~= line then
            lines[i] = new_line
            modified = true
        end
    end
    
    if modified then
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
        vim.notify("✅ Math expressions converted to Unicode!", vim.log.levels.INFO)
    else
        vim.notify("ℹ️  No math expressions found to convert", vim.log.levels.INFO)
    end
end

function M.render_current_line()
    local bufnr = vim.api.nvim_get_current_buf()
    local line_num = vim.api.nvim_win_get_cursor(0)[1]
    local line = vim.api.nvim_buf_get_lines(bufnr, line_num - 1, line_num, false)[1]
    
    if line then
        local new_line = M.process_line(line)
        if new_line ~= line then
            vim.api.nvim_buf_set_lines(bufnr, line_num - 1, line_num, false, {new_line})
            vim.notify("Line math expressions rendered!", vim.log.levels.INFO)
        else
            vim.notify("No math expressions found in current line", vim.log.levels.INFO)
        end
    end
end

function M.toggle_auto_render()
    config.auto_render = not config.auto_render
    
    if config.auto_render then
        M.setup_live_rendering()
        vim.notify("Auto-rendering enabled", vim.log.levels.INFO)
    else
        if augroup_id then
            vim.api.nvim_del_augroup_by_id(augroup_id)
            augroup_id = nil
        end
        vim.notify("Auto-rendering disabled", vim.log.levels.INFO)
    end
end

function M.get_config()
    return vim.deepcopy(config)
end

return M