class Clings < Formula
  desc "A feature-rich CLI for Things 3 on macOS"
  homepage "https://github.com/drewburchfield/clings"
  url "https://github.com/drewburchfield/clings/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "6b7b89b47296e1656a49ca1835512ff1ed81d623efa15601ef87b2cda4434e0e"
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
