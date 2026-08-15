{ ... }: {
  programs.omp = {
    enable = true;
    settings.startup.quiet = true;
  };
}
