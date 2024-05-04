{ config, pkgs, ... }:

{
  services.tailscale.enable = true;

  # http://127.0.0.1:19999/
  # services.netdata.enable = true;

  systemd.services.tailscale-autoconnect = {
    description = "Automatic connection to Tailscale";

    # make sure tailscale is running before trying to connect to tailscale
    after = [ "network-pre.target" "tailscale.service" ];
    wants = [ "network-pre.target" "tailscale.service" ];
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

  networking.firewall.checkReversePath = "loose";
  # networking.hostName = "martins3-host";

  networking.firewall = {
    # enable the firewall
    enable = true;

    # always allow traffic from your Tailscale network
    trustedInterfaces = [ "tailscale0" ];

    # allow the Tailscale UDP port through the firewall
    allowedUDPPorts = [ config.services.tailscale.port

      8472 # k3s, flannel: required if using multi-node for inter-node networking
    ];

    # allow you to SSH in over the public internet
    allowedTCPPorts = [
      22 # ssh
      5201 # iperf
      3434 # http.server
      8889 # clash
      445 # samba
      /* 8384 # syncthing */
      /* 22000 # syncthing */
      6443 # k3s: required so that pods can reach the API server (running on port 6443 by default)
      2379 # k3s, etcd clients: required if using a "High Availability Embedded etcd" configuration
      2380 # k3s, etcd peers: required if using a "High Availability Embedded etcd" configuration
    ];


    allowedTCPPortRanges = [
      { from = 5900; to = 6100; }
    ];
  };

  # wireless and wired coexist
  systemd.network.wait-online.timeout = 1;

  services.samba = {
    enable = true;

    /* syncPasswordsByPam = true; */

    # This adds to the [global] section:
    extraConfig = ''
      browseable = yes
      smb encrypt = required
    '';

    shares = {
      public = {
        path = "/home/martins3/core/winshare";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        /* "create mask" = "0644"; */
        /* "directory mask" = "0755"; */
        /* "force user" = "username"; */
        /* "force group" = "groupname"; */
      };
    };
  };


  # 配合使用
  # sudo mount -t nfs 127.0.0.1:/home/martins3/nfs /mnt
  # 这个时候居然可以删除掉 nfs ，乌鱼子
  services.nfs.server.enable = true;
  services.nfs.server.exports = ''
    /home/martins3/nfs         127.0.0.1(rw,fsid=0,no_subtree_check)
  '';
}
