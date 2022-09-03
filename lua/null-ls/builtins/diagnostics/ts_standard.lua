local h = require("null-ls.helpers")
local cmd_resolver = require("null-ls.helpers.command_resolver")
local methods = require("null-ls.methods")

local DIAGNOSTICS = methods.internal.DIAGNOSTICS

return h.make_builtin({
    name = "ts_standard",
    meta = {
        url = "https://standardjs.com/",
        description = "JavaScript style guide, linter, and formatter.",
    },
    method = DIAGNOSTICS,
    filetypes = { "typescript" },
    generator_opts = {
        command = "ts-standard",
        args = { "--stdin" },
        to_stdin = true,
        ignore_stderr = true,
        format = "line",
        check_exit_code = function(c)
            return c <= 1
        end,
        on_output = h.diagnostics.from_patterns({
            {
                pattern = ":(%d+):(%d+): Parsing error: (.*)",
                groups = { "row", "col", "message" },
                overrides = {
                    diagnostic = {
                        severity = h.diagnostics.severities.error,
                    },
                },
            },
            {
                pattern = ":(%d+):(%d+): (.*)",
                groups = { "row", "col", "message" },
                overrides = {
                    diagnostic = {
                        severity = h.diagnostics.severities.warning,
                    },
                },
            },
        }),
        dynamic_command = cmd_resolver.from_node_modules,
    },
    factory = h.generator_factory,
})
