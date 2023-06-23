return {
  init_options = {
    compilationDatabaseDirectory = "ggggg";
    index = {
      threads = 0;
    };
    clang = {
      excludeArgs = { "-Wall"} ;
    };

        client = {
          snippetSupport = true;
        }

        highlight = {
          lsRanges = true;
        }
  }

}
