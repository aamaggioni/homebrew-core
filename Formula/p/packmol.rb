class Packmol < Formula
  desc "Packing optimization for molecular dynamics simulations"
  homepage "https://www.ime.unicamp.br/~martinez/packmol/"
  url "https://github.com/m3g/packmol/archive/refs/tags/v21.0.1.tar.gz"
  sha256 "554a8a88348ad82b46e6195ff7c7698356b4a5a815c4f1c8615ef1b0651a5b9e"
  license "MIT"
  head "https://github.com/m3g/packmol.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "529f52151135c95854c4e8126850e7f61ad025b1ebfd5cedc31d00c9386a7194"
    sha256 cellar: :any,                 arm64_sonoma:  "827567a6c29a415879841924c05a76aba35cea4753820efd984393ef48ca4b82"
    sha256 cellar: :any,                 arm64_ventura: "61b15014b462dd7a017898eb4349fc2bbb5265490a2fa9661b106435977ad8d1"
    sha256 cellar: :any,                 sonoma:        "a8ff4b2fa87ef1859a29f37ebd8ced067742598f3827ad183ca66acca1625685"
    sha256 cellar: :any,                 ventura:       "ede3a08a8ef872d290599ee5d1cc2f01dfd4aab8b5c810a76451409b63a6de5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d4f7306b0d498e94fc3b5dab27aa9879b128d9fa9fe9e87a61e57b3994b76dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6031e4ae8e4ede141d319a6aa40334707782af7df4c7ecde9925d769e0dcf5c"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran

  resource "homebrew-testdata" do
    url "https://www.ime.unicamp.br/~martinez/packmol/examples/examples.tar.gz"
    sha256 "97ae64bf5833827320a8ab4ac39ce56138889f320c7782a64cd00cdfea1cf422"
  end

  # support cmake 4.0, upstream pr ref, https://github.com/m3g/packmol/pull/94
  patch do
    url "https://github.com/m3g/packmol/commit/a1da16a7f3aeb2e004a963cf92bf9e57e94e4982.patch?full_index=1"
    sha256 "5e073f744559a3b47c1b78075b445e3dd0b4e89e3918f4cbf8e651c77b83d173"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "solvate.tcl"
    (pkgshare/"examples").install resource("homebrew-testdata")
  end

  test do
    cp Dir["#{pkgshare}/examples/*"], testpath
    system bin/"packmol < interface.inp"
  end
end
