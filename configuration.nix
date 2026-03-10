{ config, lib, pkgs, inputs, ... }:

{
	imports =
		[
			./hardware-configuration.nix
			./disko.nix
			inputs.disko.nixosModules.disko
		];

	fileSystems."/mnt/driveD" = {
		device = "/dev/disk/by-uuid/5484003384001A5E";
		fsType = "ntfs";
		options = [ "rw" "uuid=1000" "gid=100" "nofail" ];
	};

	fileSystems."/mnt/driveE" = {
		device = "/dev/disk/by-uuid/F234F94234F90A7D";
		fsType = "ntfs";
		options = [ "rw" "uuid=1000" "gid=100" "nofail" ];
	};

	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	boot.kernelPackages = pkgs.linuxPackages_latest;
	boot.supportedFilesystems = [ "fuse" ];
	boot.kernelModules = [ "fuse" ];
	networking.hostName = "nixos";

	networking.networkmanager.enable = true;

	time.timeZone = "Asia/Kolkata";

	i18n.defaultLocale = "en_US.UTF-8";

	services.libinput.enable = true;
	xdg.portal = {
		enable = true;
		extraPortals = [
			pkgs.kdePackages.xdg-desktop-portal-kde
		];
	};
	services.gvfs.enable = true;
	programs.dconf.enable = true;

	users.users.meghith = {
		isNormalUser = true;
		description = "Meghith";
		extraGroups = [ "wheel" "networkmanager" "audio" "video" "input" "bluetooth" "plugdev" ];
		shell = pkgs.fish;
	};
	security.sudo.wheelNeedsPassword = true;

	programs.niri.enable = true;
	
	programs.neovim = {
		enable = true;
		defaultEditor = true;
	};	

	services.greetd = {
		enable = true;
		settings = {
			default_session = {
				command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd 'dbus-run-session niri'";
				user = "greeter";
			};
		};
	};

	security.rtkit.enable = true;

	services.pipewire = {
		enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		pulse.enable = true;
		jack.enable = true;
	};

	hardware.bluetooth.enable = true;
	hardware.bluetooth.powerOnBoot = true;
	services.blueman.enable = true;

	programs.firefox.enable = true;
	programs.fish.enable = true;

	environment.sessionVariables = {
		TERMINAL = "kitty";
		QT_QPA_PLATFORM = "wayland";
		QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
	};

	nixpkgs.config.allowUnfree = true;

	fonts.packages = with pkgs; [
		nerd-fonts.jetbrains-mono
	];

	programs.gamemode.enable = true;
	programs.nix-ld.enable = true;
	hardware.rtl-sdr.enable = true;
	xdg.mime.defaultApplications = {
		"image/png" = "nomacs.desktop";
	};

	environment.systemPackages = with pkgs; [
		vim
		wget
		curl
		git
		kitty
		kdePackages.dolphin
		kdePackages.qtsvg
		kdePackages.kio-extras
		kdePackages.kio-fuse
		kdePackages.okular
		kdePackages.kded
		nomacs
		cmus
		cava
		lutris
		wineWowPackages.stable
		winetricks
		protonup-qt
		brightnessctl
		unzip
		when
		eza
		lolcat
		pfetch
		vlc
		telegram-desktop
		signal-desktop
		sdrpp
		kdePackages.kdenlive
		frei0r
		inkscape
		gthumb
		gimp
		candy-icons
		(python3.withPackages (ps: with ps; [
			pip
			virtualenv
		]))
		usbutils
		libmtp
		jmtpfs
		steam-run
		xwayland-satellite
		fuse2
		libreoffice-fresh
		hunspell
		hunspellDicts.en_US
		rtl-sdr
		cargo
		rustc
		gcc
		yazi
		tmux
		ffmpeg
	];

	services.udev.packages = with pkgs; [
		libmtp
	];
	programs.xwayland.enable = true;
	systemd.user.services.xwayland-satellite={
		description = "Xwayland Satellite";
		wantedBy = [ "graphical-session.target" ];
		serviceConfig = {
			ExecStart = "${pkgs.xwayland-satellite}/bin/xwayland-satellite";
			Restart = "always";
		};
	};

	services.dbus.enable = true;
	services.dbus.packages = [ pkgs.kdePackages.kded ];
	services.udisks2.enable = true;
	hardware.enableRedistributableFirmware = true;
	hardware.graphics.enable32Bit = true;

	nix.settings.experimental-features = ["nix-command" "flakes"];

	networking.firewall.enable = true;

	home-manager = {
		useGlobalPkgs = true;
		useUserPackages = true;

		users.meghith = {
			imports = [
				inputs.dms.homeModules.dank-material-shell
			];

			programs.dank-material-shell = {
				enable = true;
				enableSystemMonitoring = true;
				dgop.package = inputs.dgop.packages.${pkgs.system}.default;
			};

			home.stateVersion = "25.11";
		};
	};

	system.stateVersion = "25.11";
}
