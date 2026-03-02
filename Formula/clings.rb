class Clings < Formula
  desc "A feature-rich CLI for Things 3 on macOS"
  homepage "https://github.com/drewburchfield/clings"
  url "https://github.com/drewburchfield/clings/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "54596cb4a1855c48d370706f40a4d90ead4fad184be4415ed673e12db804a869"
  license "GPL-3.0-or-later"

  depends_on :macos
  depends_on xcode: ["15.0", :build]

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"
    bin.install ".build/release/clings"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/clings --version")
  end
end
