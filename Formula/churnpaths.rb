class Churnpaths < Formula
  desc "One folder list for Spotlight, Time Machine and Backblaze churn exclusions"
  homepage "https://github.com/drewburchfield/churnpaths"
  url "https://github.com/drewburchfield/churnpaths/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "cfd40eec3d970b55a207576bf9cdb7c119a4102bc209d11f486b997d3ce4c2fa"
  license "MIT"

  depends_on "go" => :build
  depends_on :macos

  def install
    # Spotlight and Time Machine targets call Apple frameworks through cgo.
    ENV["CGO_ENABLED"] = "1"
    system "go", "build", "-mod=vendor", *std_go_args(ldflags: "-X main.version=v#{version}")
    fish_completion.install "completions/churnpaths.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/churnpaths --version")

    (testpath/"cache").mkpath
    (testpath/"list.txt").write "path #{testpath}/cache\n"
    assert_match "#{testpath}/cache", shell_output("#{bin}/churnpaths -l -j -s #{testpath}/list.txt")
  end
end
