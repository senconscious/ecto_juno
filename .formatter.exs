[
  import_deps: [:ecto],
  inputs: [
    "*.{ex,exs}",
    "priv/*/seeds.exs",
    "{config,lib}/**/*.{ex,exs}",
    "test/ecto_juno/**/*.{ex,exs}"
  ],
  subdirectories: ["test/priv/*/migrations"]
]
