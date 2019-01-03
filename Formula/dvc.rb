class Dvc < Formula
  include Language::Python::Virtualenv

  desc "Git for data science projects"
  homepage "https://dataversioncontrol.com/"
  url "https://github.com/iterative/dvc/archive/0.23.2.tar.gz"

  depends_on "pkg-config" => :build
  depends_on "python"
  depends_on

  def install
    venv = virtualenv_create(libexec)
    system libexec/"bin/pip", "install", "-r", "requirements.txt"
    # NOTE: dvc depends on asciimatics, which depends on Pillow, which
    # uses liblcms2.2.dylib that causes troubles on mojave. See
    # https://github.com/iterative/homebrew-dvc/issues/9 for more info.
    # As a workaround, we need to simply uninstall Pillow before our
    # next step.
    system libexec/"bin/pip", "uninstall", "-y", "asciimatics"
    system libexec/"bin/pip", "uninstall", "-y", "Pillow"
    system libexec/"bin/pip", "install", "git+https://github.com/efiop/asciimatics"
    venv.pip_install_and_link buildpath
  end

  test do
    system "#{bin}/dvc", "--version"
  end
end
