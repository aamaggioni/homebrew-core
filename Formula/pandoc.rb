class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.15/pandoc-2.15.tar.gz"
  sha256 "2e09c69a9aedaf99a50760dcb94031f802efdefd22ecefd0d3ee5444101f2e3d"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/pandoc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc73fff9e7b8835ae86eb31ee3bec218f6b15c5054d062359f219b6e0d3dde87"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "817369a3214c250c65b9d6fd6bd206520c333ea55832e1e74b8d7b49002a7bed"
    sha256 cellar: :any_skip_relocation, monterey:       "eba0a237c7f86571c80c6bda88f574747ec3f784d32abdf8fd42a62282de98d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "2b5eb56d4c06ff7350259d7b8dfc67291a389913b935c7cbfa0cd34b735fa728"
    sha256 cellar: :any_skip_relocation, catalina:       "86246ec052a743cec4b83cb339fbfbe8016a13b22c8f69a7dfe2d5d12341ecbe"
    sha256 cellar: :any_skip_relocation, mojave:         "0bda1c5a703f8cc92861fde63cfb6d54f8d6bb363f4d3d096f95237147b38d54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c09c9b6af88a867dc7a67d5f81e711ec4250c12c53b868758c4b5857f35d81c"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  uses_from_macos "unzip" => :build # for cabal install
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
    (bash_completion/"pandoc").write `#{bin}/pandoc --bash-completion`
    man1.install "man/pandoc.1"
  end

  test do
    input_markdown = <<~EOS
      # Homebrew

      A package manager for humans. Cats should take a look at Tigerbrew.
    EOS
    expected_html = <<~EOS
      <h1 id="homebrew">Homebrew</h1>
      <p>A package manager for humans. Cats should take a look at Tigerbrew.</p>
    EOS
    assert_equal expected_html, pipe_output("#{bin}/pandoc -f markdown -t html5", input_markdown)
  end
end
