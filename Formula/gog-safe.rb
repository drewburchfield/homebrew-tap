class GogSafe < Formula
  desc "Google Workspace CLI with agent-safe profile (no send/delete/share)"
  homepage "https://github.com/drewburchfield/gogcli-safe"
  url "https://github.com/drewburchfield/gogcli-safe/archive/da8e771e021dea4b83c86716506a1162363d8e97.tar.gz"
  version "0.12.0-safe"
  sha256 "8992894b16d27ebb5889c3a9cb1eb3c72ce4d0d08c4bc0d4b547cf448ae2704b"
  license "MIT"

  depends_on "go" => :build

  def install
    # Generate trimmed command structs from the agent-safe profile.
    # This profile allows read + draft + archive + label operations
    # but blocks send, delete, share, and admin commands.
    system "go", "run", "./cmd/gen-safety", "--strict", "safety-profiles/agent-safe.yaml"

    commit = "da8e771e021d"
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
