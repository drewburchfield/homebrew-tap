class GogSafe < Formula
  desc "Google Workspace CLI with agent-safe profile (no send/delete/share)"
  homepage "https://github.com/drewburchfield/gogcli-safe"
  url "https://github.com/drewburchfield/gogcli-safe/archive/8c8ae9ffbdb4d8a422ea719eb039281b3e402d9b.tar.gz"
  version "0.12.0-safe.1"
  sha256 "1a82a69b4075be915c4d853e984b84f70b8826b4b8c14756e4ba957173f88ed1"
  license "MIT"

  depends_on "go" => :build

  def install
    # Generate trimmed command structs from the agent-safe profile.
    # This profile allows read + draft + archive + label operations
    # but blocks send, delete, share, and admin commands.
    system "go", "run", "./cmd/gen-safety", "--strict", "safety-profiles/agent-safe.yaml"

    commit = "8c8ae9ffbdb4"
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
