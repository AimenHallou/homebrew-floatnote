class Floatnote < Formula
  desc "Minimal floating sticky note for macOS — translucent, always on top"
  homepage "https://github.com/AimenHallou/floatnote"
  url "https://github.com/AimenHallou/floatnote/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "9ce2268976902678de8d6dbc38c8fd861089003674f9c53aeadba2cd9a25bdce"
  license "MIT"

  depends_on :macos => :ventura

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "--product", "FloatNote"

    # The binary may be at FloatNote or floatnote depending on the system
    binary = if File.exist?(".build/release/FloatNote")
      ".build/release/FloatNote"
    else
      ".build/release/floatnote"
    end

    bin.install binary => "floatnote"

    # Build the .app bundle
    app_dir = prefix/"FloatNote.app/Contents"
    (app_dir/"MacOS").mkpath
    cp binary, app_dir/"MacOS/FloatNote"
    if File.exist?("Sources/FloatNote/Resources/Info.plist")
      cp "Sources/FloatNote/Resources/Info.plist", app_dir/"Info.plist"
    end
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
    assert_predicate bin/"floatnote", :executable?
  end
end
