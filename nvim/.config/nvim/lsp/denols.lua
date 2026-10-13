return {
  init_options = {
    -- Only load open files and their imports instead of the whole workspace
    documentPreloadLimit = 0,
    -- Cap the TS server heap in MB (default 3072); raise to 2048 if it crashes
    maxTsServerMemory = 1536,
  },
}
