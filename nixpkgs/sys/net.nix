{ config, pkgs, ... }:

{
  services.tailscale.enable = true;

  # http://127.0.0.1:19999/
  # services.netdata.enable = true;

  systemd.services.tailscale-autoconnect = {
    description = "Automatic connection to Tailscale";

    # make sure tailscale is running before trying to connect to tailscale
    after = [
      "network-pre.target"
      "tailscale.service"
    ];
    wants = [
      "network-pre.target"
      "tailscale.service"
    ];
    wantedBy = [ "multi-user.target" ];

    # set this service as a oneshot job
    serviceConfig.Type = "oneshot";

    # have the job run this shell script
    script = with pkgs; ''
      # wait for tailscaled to settle
      sleep 2

      # check if we are already authenticated to tailscale
      status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
      if [ $status = "Running" ]; then # if so, then do nothing
        exit 0
      fi

      # otherwise authenticate with tailscale
      ${tailscale}/bin/tailscale up -authkey $(cat /home/martins3/.tailscale-credentials)
    '';
  };

  networking.nat = {
    enable = false;
    internalInterfaces = [ "br-in" ];
    externalInterface = "wlo1";
    internalIPs = [ "10.0.0.0/16" ];
  };

  networking.firewall.checkReversePath = "loose";
  # networking.hostName = "martins3-host";

  networking.firewall = {
    # enable the firewall
    enable = true;

    # always allow traffic from your Tailscale network
    trustedInterfaces = [ "tailscale0" ];

    # allow the Tailscale UDP port through the firewall
    allowedUDPPorts = [
      config.services.tailscale.port

      8472 # k3s, flannel: required if using multi-node for inter-node networking
    ];

    # allow you to SSH in over the public internet
    allowedTCPPorts = [
      22 # ssh
      5201
      5202
      5203 # iperf3
      8889 # clash
      445 # samba
      # 8384 # syncthing
      # 22000 # syncthing
      2049 # nfs
    ];

    allowedTCPPortRanges = [
      {
        from = 50000;
        to = 60000;
      }
    ];
  };

  # wireless and wired coexist
  systemd.network.wait-online.timeout = 1;

  services.samba = {
    enable = true;

    # syncPasswordsByPam = true;

    settings = {
      # This adds to the [global] section:
      global = {
        browseable = "yes";
        "smb encrypt" = "required";
      };

      public = {
        path = "/home/martins3/core/winshare";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        # "create mask" = "0644";
        # "directory mask" = "0755";
        # "force user" = "username";
        # "force group" = "groupname";
      };

      hack = {
        path = "/home/martins3/hack";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "yes";
      };
    };
  };

  # networking.proxy.default = "http://127.0.0.1:8889";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # 配合使用
  # sudo mount -t nfs4 10.0.0.2:/home/martins3/hack /home/martins3/hack
  # 有的 guest os 环境必须用 mount.nfs
  # sudo mount.nfs 10.0.0.2:/home/martins3/core/vn /home/martins3/core/vn
  # 1. 这个时候居然可以删除掉 nfs ，乌鱼子
  # 2. 如果不增加 no_root_squash ，在 fedora 虚拟机中没有 write 权限，但是在 nixos guest 中可以，因为 feodra 默认 root
  #   - https://serverfault.com/questions/611007/unable-to-write-to-mount-point-nfs-server-getting-permission-denied
  #   - 但是加上了之后，nixos guest 无法访问了
  services.nfs.server.enable = true;
  services.nfs.server.exports = ''
    /home/martins3/hack         10.0.0.2/16(rw,no_subtree_check)
    /home/martins3/core/vn      10.0.0.2/16(rw,no_subtree_check)
  '';
}
