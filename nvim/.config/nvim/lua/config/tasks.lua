local M = {}

local frontend_filetypes = {
    html = true,
    css = true,
    scss = true,
    less = true,
    javascript = true,
    javascriptreact = true,
    typescript = true,
    typescriptreact = true,
    vue = true,
    svelte = true,
    astro = true,
    json = true,
    jsonc = true,
}

-- Utils
local function notify(message, level)
    vim.notify(message, level or vim.log.levels.INFO)
end

local function current_file()
    local file = vim.api.nvim_buf_get_name(0)

    if file == "" then
        return nil
    end

    return vim.fs.normalize(file)
end

local function find_root(markers)
    local file = current_file()

    if not file then
        return vim.uv.cwd()
    end

    return vim.fs.root(file, markers) or vim.fs.dirname(file)
end

local function has_file(root, names)
    for _, name in ipairs(names) do
        if vim.uv.fs_stat(vim.fs.joinpath(root, name)) then
            return true
        end
    end

    return false
end

-- Terminal
local function run_in_terminal(command, cwd)
    if vim.bo.modified and vim.bo.buftype == "" then
        vim.cmd("silent! write")
    end

    vim.cmd("botright 15split")
    vim.cmd("terminal")

    local job = vim.bo.channel

    vim.fn.chansend(job, {
        "cd " .. vim.fn.shellescape(cwd),
        command,
        "",
    })

    vim.cmd("startinsert")
end

-- Project detection
local function project_type()
    local filetype = vim.bo.filetype

    if filetype == "rust" then
        return "rust"
    end

    if filetype == "c" or filetype == "cpp" then
        return "c"
    end

    if frontend_filetypes[filetype] then
        return "frontend"
    end

    return nil
end

local function rust_root()
    return find_root({ "Cargo.toml", ".git" })
end

local function c_root()
    return find_root({ "Makefile", "makefile", "CMakeLists.txt", ".git" })
end

local function frontend_root()
    return find_root({ "package.json", ".git" })
end

local function package_manager(root)
    if has_file(root, { "pnpm-lock.yaml" }) then
        return "pnpm"
    end

    if has_file(root, { "bun.lock", "bun.lockb" }) then
        return "bun"
    end

    if has_file(root, { "yarn.lock" }) then
        return "yarn"
    end

    return "npm"
end

local function package_scripts(root)
    local path = vim.fs.joinpath(root, "package.json")
    local ok, lines = pcall(vim.fn.readfile, path)

    if not ok then
        return {}
    end

    local decoded_ok, package = pcall(vim.json.decode, table.concat(lines, "\n"))

    if not decoded_ok or type(package) ~= "table" then
        return {}
    end

    return package.scripts or {}
end

-- Runs the first script that exists in package.json
local function run_script(candidates)
    local root = frontend_root()
    local scripts = package_scripts(root)

    for _, script in ipairs(candidates) do
        if scripts[script] then
            run_in_terminal(package_manager(root) .. " run " .. script, root)
            return
        end
    end

    notify(
        "package.json no tiene ninguno de estos scripts: " .. table.concat(candidates, ", "),
        vim.log.levels.WARN
    )
end

local function c_compile_command(file, and_run)
    local is_cpp = vim.bo.filetype == "cpp"
    local output = vim.fn.fnamemodify(file, ":r")

    local command = {
        is_cpp and "clang++" or "clang",
        is_cpp and "-std=c++20" or "-std=c17",
        "-Wall",
        "-Wextra",
        "-Wpedantic",
        "-g",
        vim.fn.shellescape(file),
        "-o",
        vim.fn.shellescape(output),
    }

    if and_run then
        vim.list_extend(command, { "&&", vim.fn.shellescape(output) })
    end

    return table.concat(command, " ")
end

local function unsupported(action)
    notify(action .. " is only configured for frontend, C, C++ and Rust", vim.log.levels.WARN)
end

-- Build
function M.build()
    local kind = project_type()

    if kind == "frontend" then
        run_script({ "build" })
    elseif kind == "rust" then
        run_in_terminal("cargo build", rust_root())
    elseif kind == "c" then
        local root = c_root()

        if has_file(root, { "Makefile", "makefile" }) then
            run_in_terminal("make", root)
            return
        end

        local file = current_file()

        if not file then
            notify("No C file opened", vim.log.levels.WARN)
            return
        end

        run_in_terminal(c_compile_command(file, false), root)
    else
        unsupported("Build")
    end
end

-- Run
function M.run()
    local kind = project_type()

    if kind == "frontend" then
        run_script({ "dev", "start", "preview" })
    elseif kind == "rust" then
        run_in_terminal("cargo run", rust_root())
    elseif kind == "c" then
        local root = c_root()

        if has_file(root, { "Makefile", "makefile" }) then
            notify("For C projects with Makefile use: :Task make run")
            return
        end

        local file = current_file()

        if not file then
            notify("No C file opened", vim.log.levels.WARN)
            return
        end

        run_in_terminal(c_compile_command(file, true), root)
    else
        unsupported("Run")
    end
end

-- Test
function M.test()
    local kind = project_type()

    if kind == "frontend" then
        run_script({ "test", "test:unit" })
    elseif kind == "rust" then
        run_in_terminal("cargo test", rust_root())
    elseif kind == "c" then
        local root = c_root()

        if has_file(root, { "Makefile", "makefile" }) then
            run_in_terminal("make test", root)
            return
        end

        notify("C project needs target 'test' in the Makefile", vim.log.levels.WARN)
    else
        unsupported("Test")
    end
end

-- Lint
function M.lint()
    local kind = project_type()

    if kind == "frontend" then
        run_script({ "lint", "check", "typecheck" })
    elseif kind == "rust" then
        run_in_terminal("cargo clippy", rust_root())
    else
        unsupported("Lint")
    end
end

-- Arbitrary command
function M.task(command)
    if not command or command == "" then
        notify("You need to provide a command", vim.log.levels.WARN)
        return
    end

    local kind = project_type()
    local root

    if kind == "rust" then
        root = rust_root()
    elseif kind == "frontend" then
        root = frontend_root()
    elseif kind == "c" then
        root = c_root()
    else
        root = find_root({
            "package.json",
            "Cargo.toml",
            "Makefile",
            "makefile",
            "CMakeLists.txt",
            ".git",
        })
    end

    run_in_terminal(command, root)
end

return M
