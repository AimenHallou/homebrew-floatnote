class Floatnote < Formula
  desc "Minimal floating sticky note for macOS — translucent, always on top"
  homepage "https://github.com/AimenHallou/floatnote"
  url "https://github.com/AimenHallou/floatnote/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "60bf414efdbc76c4c829222ee74b1d776fe07614ccc4de406d039d522006a105"
  license "MIT"

  depends_on :macos => :ventura
  depends_on xcode: ["14.0", :build]

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"

    # Install the binary
    bin.install ".build/release/FloatNote"

    # Build the .app bundle
    app_dir = prefix/"FloatNote.app/Contents"
    (app_dir/"MacOS").mkpath
    cp ".build/release/FloatNote", app_dir/"MacOS/FloatNote"
    cp "Sources/FloatNote/Resources/Info.plist", app_dir/"Info.plist"
  end

  def caveats
    <<~EOS
      FloatNote has been installed. You can run it two ways:

        1. As a command:    floatnote
        2. As an app:       open #{opt_prefix}/FloatNote.app

      On first launch, grant Accessibility permission for the global hotkey:
        System Settings → Privacy & Security → Accessibility
    EOS
  end

  test do
    assert_predicate bin/"FloatNote", :executable?
  end
end
