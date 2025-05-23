{ ... }: final: prev:
let
  # NLTK data derivations
  punkt_tokenizer = prev.stdenv.mkDerivation {
    name = "nltk-punkt";
    src = prev.fetchurl {
      url = "https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/tokenizers/punkt_tab.zip";
      sha256 = "1vapcvqz71s6j3xj5ycvh6i3phcp2dhammw9azfgpvrqswinrcf2";
    };
    buildInputs = [ prev.unzip ];
    installPhase = ''
      mkdir -p $out/tokenizers
      unzip $src -d $out/tokenizers/
    '';
  };

  stopwords = prev.stdenv.mkDerivation {
    name = "nltk-stopwords";
    src = prev.fetchurl {
      url = "https://raw.githubusercontent.com/nltk/nltk_data/gh-pages/packages/corpora/stopwords.zip";
      sha256 = "1l819c59j87356wrnw0z458dc9wzmf660rf2xldwl9bli1wl3j8m";
    };
    buildInputs = [ prev.unzip ];
    installPhase = ''
      mkdir -p $out/corpora
      unzip $src -d $out/corpora/
    '';
  };

  # Combined NLTK data directory
  nltk_data = prev.symlinkJoin {
    name = "nltk-data";
    paths = [
      punkt_tokenizer
      stopwords
    ];
  };

  extraDependencies = with prev.python3.pkgs; [
    dataclasses-json
    deprecated
    dirtyjson
    filetype
    joblib
    llama-index-core
    llama-index-embeddings-huggingface
    marshmallow
    mpmath
    mypy-extensions
    nest-asyncio
    nltk
    safetensors
    scikit-learn
    sentence-transformers
    sqlalchemy
    sympy
    tenacity
    threadpoolctl
    transformers
    typing-inspect
    wrapt
  ];

  addDeps = pkg: pkg.overridePythonAttrs (oldAttrs: {
    dependencies = oldAttrs.dependencies ++ extraDependencies;
    makeWrapperArgs = (oldAttrs.makeWrapperArgs or []) ++ [
      "--set NLTK_DATA ${nltk_data}"
    ];
  });
in
{
  aider-chat = addDeps prev.aider-chat.withPlaywright;
}
