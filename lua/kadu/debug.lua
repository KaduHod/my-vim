local dap = require("dap")
local dapui = require("dapui")
local debuggersPath = os.getenv("HOME") .. "/debuggers"
vim.keymap.set('n', '<leader>b', function() dap.toggle_breakpoint() end)
vim.keymap.set('n', '<F1>', function() require('dap').continue() end)
vim.keymap.set('n', '<F2>', function() require('dap').step_over() end)
vim.keymap.set('n', '<F3>', function() require('dap').step_into() end)
vim.keymap.set('n', '<F4>', function() require('dap').step_out() end)
dapui.setup()
vim.keymap.set('n', '<F5>', require('dapui').toggle, { desc = 'Toggle debug UI' })


-- open Dap UI automatically when debug starts (e.g. after <F5>)
dap.listeners.before.attach.dapui_config = function()
    dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
    dapui.open()
end
-- close Dap UI with :DapCloseUI
vim.api.nvim_create_user_command("DapCloseUI", function()
    require("dapui").close()
end, {})
dap.configurations.brs = {
    {
        type = 'brightscript',
        request = 'launch',
        name = "Debug app",
        rootDir = "${workspaceFolder}",
        files = {
            "manifest",
            "source/**/*.*",
            "components/**/*.*",
            "images/**/*.*",
            "locale/**/*.*"
        },
        host = "${env:ROKU_DEV_TARGET}",
        remotePort = 8060,
        password = "${env:DEVPASSWORD}",
        outDir = "${workspaceFolder}/out/",
        enableDebugProtocol = true,
        fileLogging = false,
        enableVariablesPanel = true,
        logLevel = "off"
    },
}
dap.adapters["pwa-node"] = {
    type = "server",
    host = "localhost",
    port = "${port}",
    executable = {
        command = "node",
        args = { debuggersPath .. "/js-debug/src/dapDebugServer.js", "${port}" },
    }
}
dap.configurations.javascript = {
    {
        type = "pwa-node",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        cwd = "${workspaceFolder}",
    },
}
--[[dap.adapters.node2 = {
    type = 'executable',
    command = 'node',
    args = { debuggersPath .. '/debuggers/vscode-node-debug2/out/src/nodeDebug.js' },
}
dap.configurations.javascript = {
    {
        name = 'Launch',
        type = 'node2',
        request = 'launch',
        program = '${file}',
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = 'inspector',
        console = 'integratedTerminal',
    },
    {
        -- For this to work you need to make sure the node process is started with the `--inspect` flag.
        name = 'Attach to process',
        type = 'node2',
        request = 'attach',
        processId = require 'dap.utils'.pick_process,
    },
}]]--
dap.adapters.php = {
    type = 'executable',
    command = 'node',
    args = { debuggersPath .. '/vscode-php-debug/out/phpDebug.js' }
}

dap.configurations.php = {
    {
        type = 'php',
        request = 'launch',
        name = 'Listen for Xdebug',
        port = 9003
    }
}
dap.adapters.go = {
  type = 'executable';
  command = 'node';
  args = {debuggersPath .. '/vscode-go/extension/dist/debugAdapter.js'};
}
dap.configurations.go = {
  {
    type = 'go';
    name = 'Debug';
    request = 'launch';
    showLog = false;
    program = "${file}";
    dlvToolPath = vim.fn.exepath('dlv')  -- Adjust to where delve is installed
  },
}
