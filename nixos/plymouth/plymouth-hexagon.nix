{ stdenv, fetchurl }:

stdenv.mkDerivation {
  pname = "plymouth-theme-hexagon";
  version = "1.0";

  src = fetchurl {
    url = "https://github.com/adi1090x/plymouth-themes/releases/download/v1.0/hexagon_alt.tar.gz";
    sha256 = "1f6i8signlscp0av3kcmdw0xm13pf2dy2lz3c6wq9d9203ibry1p";
  };

  installPhase = ''
    mkdir -p $out/share/plymouth/themes
    cp -r hexagon_alt $out/share/plymouth/themes/
  '';
}
