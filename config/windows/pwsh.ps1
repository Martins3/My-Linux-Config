function intel {
	    param(
	            [string]$user = "martins3"
		        )
	        ssh $user@10.0.0.2
}

function n100 {
	    param(
	            [string]$user = "root"
		        )
	        ssh $user@10.0.0.5
}

function wifi {
	    param(
	            [string]$user = "martins3"
		        )
	        ssh $user@192.168.11.3
}

function q {
	exit
}

function c {
	clear
}

oh-my-posh init pwsh | Invoke-Expression
