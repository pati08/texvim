pkgs: let
  opts = {
    # Line numbers
    number = true;
    relativenumber = true;

    # Always show the signcolumn, otherwise text would be shifted when displaying error icons
    signcolumn = "yes";

    # Search
    ignorecase = true;
    smartcase = true;

    # Tab defaults (might get overwritten by an LSP server)
    tabstop = 4;
    shiftwidth = 4;
    softtabstop = 0;
    expandtab = true;
    smarttab = true;

    # folding
    foldmethod = "indent";
    foldlevelstart = 99;

    # color column
    colorcolumn="80";

    # System clipboard support, needs xclip/wl-clipboard
    # clipboard = "unnamedplus";

    # Highlight the current line
    cursorline = true;

    # Show line and column when searching
    ruler = true;

    # Global substitution by default
    gdefault = true;

    # Start scrolling when the cursor is X lines away from the top/bottom
    scrolloff = 5;

    conceallevel = 1;
  };
in {
  inherit opts;
  globalOpts = opts;

  colorschemes.catppuccin = {
    enable = true;
    settings = {
      no_bold = false;
      no_italic = false;
      no_underline = false;
      transparent_background = true;
      integrations = {
        cmp = true;
        noice = true;
        treesitter = true;
        treesitter_context = true;
        telescope.enabled = true;
        indent_blankline.enabled = true;
        native_lsp = {
          enabled = true;
          inlay_hints = {
            background = true;
          };
          underlines = {
            errors = ["underline"];
            hints = ["underline"];
            information = ["underline"];
            warnings = ["underline"];
          };
        };
      };
    };
  };
  plugins = {
    lualine.enable = true;
    treesitter = {
      enable = true;
      settings.highlight.enable = true;
    };
    luasnip.enable = true;
    comment = {
      enable = true;
      settings.sticky = true;
    };
    noice.enable = true;
    telescope = {
      enable = true;
      extensions = {
        fzf-native.enable = true;
      };
    };
    nvim-tree = {
      enable = true;
      git = {
        enable = true;
        ignore = true;
      };
      diagnostics = {
        enable = true;
        showOnDirs = true;
        showOnOpenDirs = false;
      };
      actions.openFile.quitOnOpen = true;
      modified.enable = true;
      renderer = {
        addTrailing = true;
      };
      view.width = 40;
    };
    vim-surround.enable = true;
    floaterm.enable = true;
    nix.enable = true;
    statuscol.enable = true;
    nvim-autopairs.enable = true;
    web-devicons.enable = true;
    lsp = {
      enable = true;
      servers = {
        texlab.enable = true;
      };
    };
    alpha = {
      enable = true;
      theme = "dashboard";
    };
    cmp = {
      enable = true;
      settings = {
        mapping = {
          __raw = /* lua */ ''
            cmp.mapping.preset.insert({
              ["<C-p>"] = cmp.mapping.select_prev_item(),
              ["<C-n>"] = cmp.mapping.select_next_item(),
              -- Add tab support
              ["<C-d>"] = cmp.mapping.scroll_docs(-4),
              ["<C-f>"] = cmp.mapping.scroll_docs(4),
              ["<Tab>"] = cmp.mapping.confirm({
                behavior = cmp.ConfirmBehavior.Insert,
                select = true,
              }),
            })
          '';
        };
        snippet = {
          expand = "function(args) require('luasnip').lsp_expand(args.body) end";
        };
        sources = [
          { name = "nvim_lsp"; }
          # { name = "vsnip"; }
          { name = "luasnip"; }
          { name = "path"; }
          { name = "buffer"; }
        ];
      };
    };

    vimtex = {
      enable = true;
      texlivePackage = pkgs.texliveFull;
      settings = {
        view_method = "zathura";
        quickfix_mode = 0;
      };
    };
  };
  extraConfigLua = /* lua */ ''
    -- require("ultimate-autopair").setup({})
  '';

  extraConfigVim = ''
    map f <Plug>Sneak_f
    map F <Plug>Sneak_F
    map t <Plug>Sneak_t
    map T <Plug>Sneak_T
  '';

  extraPlugins = with pkgs.vimPlugins;
    [
      # ultimate-autopair-nvim
      vim-sneak
    ];
  diagnostics = {
    virtual_text = {
      severity = {
        # This defines the priority order of diagnostic severity
        # min = vim.diagnostic.severity.HINT;
        min = { __raw = "vim.diagnostic.severity.HINT"; };
        max = { __raw = "vim.diagnostic.severity.ERROR"; };
      };
      # Show only the highest priority diagnostic on a line
      severity_sort = true;
    };
    float = {
      source = "always"; # You can also include the source of the diagnostic
    };
    signs = true; # Show signs on the left column
    underline = true; # Underline diagnostics
    update_in_insert = false; # Update diagnostics only in normal mode
  };

  globals.mapleader = " ";

  highlight = {
    Comment = {
      fg = "#ff00ff";
      bg = "#000000";
      underline = true;
      bold = true;
    };
  };

  keymaps = import ./nixvimbinds.nix;
}
