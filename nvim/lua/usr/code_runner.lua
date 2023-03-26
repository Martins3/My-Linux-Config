local function microsoft_edge()
  if vim.fn.has('macunix') then
    return "/Applications/Microsoft\\ Edge.app/Contents/MacOS/Microsoft\\ Edge $file"
  else
    return "microsoft-edge-dev $fileName"
  end
end

require('code_runner').setup {
  term = {
    position = "belowright",
    size = 15,
  },
  filetype = {
    python = "python3 $file",
    c = "cd $dir ; gcc -Wall -lpthread -fno-omit-frame-pointer -pg -g -lm $fileName -o $fileNameWithoutExt.out ; $dir/$fileNameWithoutExt.out",
    cpp = "cd $dir ; g++ -std=c++20 -lpthread -g $fileName -o $fileNameWithoutExt.out  ; $dir/$fileNameWithoutExt.out",
    sh = "bash $file",
    html = microsoft_edge(),
    rust = "cargo run",
    r = "Rscript $file",
    lua = "lua $file",
    nix = "nix eval -f $file",
    nu = "if (nu-check $file ) == false { nu $file }"
  },
}

vim.api.nvim_create_autocmd('FileType', {
	desc = 'auto check nushell code on save',

	pattern = 'nu',
	group = vim.api.nvim_create_augroup('check nushell', { clear = true }),
	callback = function (opts)
		vim.api.nvim_create_autocmd('BufWritePost', {
			buffer = opts.buf,
			command = 'RunCode'
		})
	end,
})
