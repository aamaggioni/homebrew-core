class AwsCdk < Formula
  desc "AWS Cloud Development Kit - framework for defining AWS infra as code"
  homepage "https://github.com/aws/aws-cdk"
  url "https://registry.npmjs.org/aws-cdk/-/aws-cdk-2.1000.3.tgz"
  sha256 "e19303d6d32dd4cc926b3e36345a6638e5d0403636a0126ca76cb9bb50b0295f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d9b4c1965ff62c8d96589fb0b4eb681283493feeb19621e60c8149cb8c9ae2be"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    # `cdk init` cannot be run in a non-empty directory
    mkdir "testapp" do
      shell_output("#{bin}/cdk init app --language=javascript")
      list = shell_output("#{bin}/cdk list")
      cdkversion = shell_output("#{bin}/cdk --version")
      assert_match "TestappStack", list
      assert_match version.to_s, cdkversion
    end
  end
end
