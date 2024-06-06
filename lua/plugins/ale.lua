return {
    {
        'dense-analysis/ale',
        config = function()
            -- Configuration goes here.
            local g = vim.g

            g.ale_ruby_rubocop_auto_correct_all = 1
            g.ale_cpp_clang_format_options = '--style=file'
            g.ale_c_clang_format_options = '--style=file'

            g.ale_linters = {
                ruby = {'rubocop', 'ruby'},
                lua = {'lua_language_server'},
                cpp = {'clangd'},
                c = {'clangd'},
            }

            g.ale_fixers = {
                c = {'clang-format'},
                cpp = {'clang-format'},
            }
        end
    }
}
