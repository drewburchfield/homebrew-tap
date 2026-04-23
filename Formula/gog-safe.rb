class GogSafe < Formula
  desc "Google Workspace CLI with agent-safe profile (no send/delete/share)"
  homepage "https://github.com/drewburchfield/gogcli-safe"
  url "https://github.com/drewburchfield/gogcli-safe/archive/7a834d5ed28e4264093d6b62587ddcedca58d77b.tar.gz"
  version "0.13.0-safe.1"
  sha256 "91c6dc769f289576d44cd5e43c753f2345563b42d60ef0402030d41ca8b3fba1"
  license "MIT"

  depends_on "go" => :build

  def install
    # Generate trimmed command structs from the agent-safe profile.
    # This profile allows read + draft + archive + label operations
    # but blocks send, delete, share, and admin commands.
    system "go", "run", "./cmd/gen-safety", "--strict", "safety-profiles/agent-safe.yaml"

    commit = "7a834d5ed28e"
    ldflags = %W[
      -X github.com/steipete/gogcli/internal/cmd.version=#{version}
      -X github.com/steipete/gogcli/internal/cmd.commit=#{commit}
      -X github.com/steipete/gogcli/internal/cmd.date=#{time.iso8601}
    ]
    system "go", "build", "-tags", "safety_profile",
           *std_go_args(ldflags:, output: bin/"gog-safe"), "./cmd/gog/"
  end

  test do
    assert_match "safe", shell_output("#{bin}/gog-safe --version")
  end
end
