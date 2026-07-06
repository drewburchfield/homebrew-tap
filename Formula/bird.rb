class Bird < Formula
  desc "CLI for reading and posting to X/Twitter via GraphQL (cookie auth)"
  homepage "https://www.npmjs.com/package/@steipete/bird"
  url "https://registry.npmjs.org/@steipete/bird/-/bird-0.8.0.tgz"
  # npm package is deprecated and upstream repo is gone; mirror is a verbatim
  # copy of the npm tarball (MIT LICENSE file ships inside it)
  mirror "https://raw.githubusercontent.com/drewburchfield/homebrew-tap/main/vendor/steipete-bird-0.8.0.tgz"
  sha256 "2f8332b9d2e0712d748f8ea00a491ec544924d326a618b00e63f439ddea444bd"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bird --version")
  end
end
