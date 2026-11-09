class Paperfeed < Formula
  desc "Scan from an AirScan (eSCL) printer's document feeder to PDF"
  homepage "https://github.com/drewburchfield/paperfeed"
  url "https://github.com/drewburchfield/paperfeed/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "cb8a268ac05aa744faa2622a28e1f2d82d308ee242450183ec946c980791e304"
  license "MIT"

  depends_on "python@3.14"

  def install
    # Pure standard library: ship the package and run it with Homebrew's Python.
    libexec.install "bin", "paperfeed"
    (bin/"paperfeed").write <<~SH
      #!/bin/bash
      exec "#{formula_opt_bin("python@3.14")}/python3.14" "#{libexec}/bin/paperfeed" "$@"
    SH
  end

  test do
    assert_match "usage: paperfeed", shell_output("#{bin}/paperfeed --help")
  end
end
