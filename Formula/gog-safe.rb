class GogSafe < Formula
  desc "Google Workspace CLI with agent-safe profile (no send/delete/share)"
  homepage "https://github.com/drewburchfield/gogcli-safe"
  url "https://github.com/drewburchfield/gogcli-safe/archive/refs/tags/v0.34.1-safe.1.tar.gz"
  version "0.34.1-safe.1"
  sha256 "1936315e3f55bcbf72bea4527c6d1e9109ee891ec4821c7454095610f0a7c45a"
  license "MIT"

  depends_on "go" => :build

  def install
    # Bake the curated agent-safe policy into the binary via upstream's
    # bake-safety-profile tool. Disabled commands are absent from --help
    # and rejected at the kong parser layer with a profile-name diagnostic.
    system "go", "run", "./cmd/bake-safety-profile",
           "safety-profiles/agent-safe.yaml",
           "internal/cmd/safety_profile_baked_gen.go"

    commit = "617b3091ad86"
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
    assert_match "blocked by baked safety profile",
                 shell_output("#{bin}/gog-safe gmail send --to a@b.c --subject x --body y 2>&1", 2)
    # draft delete is allowed in this profile, so it stays visible in --help
    # (disabled commands are absent); draft send remains blocked.
    assert_match "delete", shell_output("#{bin}/gog-safe gmail drafts --help 2>&1")
  end
end
