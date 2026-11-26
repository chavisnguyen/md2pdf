class Md2pdf < Formula
  desc "Render Markdown files into styled PDF proposals with embedded typography"
  homepage "https://github.com/chavisnguyen/md2pdf"
  license "MIT"

  # NOTE: `url`/`sha256` below are rewritten on every published Release by
  # the "Release assets" workflow (.github/workflows/release.yml). Do not edit
  # by hand. (`version` is inferred from the tag in the URL.)
  livecheck do
    url :homepage
    strategy :github_latest
  end

  depends_on "node"

  on_macos do
    on_arm do
      url "https://github.com/chavisnguyen/md2pdf/releases/download/v0.1.0/md2pdf-darwin-arm64.tar.gz"
      sha256 "ba2c40dd3e7a32597bd894bab77db61b7f589bad4c389148c9f7a9d379162a73"
    end
    on_intel do
      url "https://github.com/chavisnguyen/md2pdf/releases/download/v0.1.0/md2pdf-darwin-amd64.tar.gz"
      sha256 "ba2c40dd3e7a32597bd894bab77db61b7f589bad4c389148c9f7a9d379162a73"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/chavisnguyen/md2pdf/releases/download/v0.1.0/md2pdf-linux-arm64.tar.gz"
      sha256 "ba2c40dd3e7a32597bd894bab77db61b7f589bad4c389148c9f7a9d379162a73"
    end
    on_intel do
      url "https://github.com/chavisnguyen/md2pdf/releases/download/v0.1.0/md2pdf-linux-amd64.tar.gz"
      sha256 "ba2c40dd3e7a32597bd894bab77db61b7f589bad4c389148c9f7a9d379162a73"
    end
  end

  def install
    bin.install "md2pdf"
    pkgshare.install "style.css"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/md2pdf --version")
    assert_predicate pkgshare/"style.css", :exist?
  end
end
