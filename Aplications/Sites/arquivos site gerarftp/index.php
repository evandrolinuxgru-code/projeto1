 <!DOCTYPE html>
<!-- code by webdevtrick ( https://webdevtrick.com) -->
<html>
	<head>
		<title>Cliente SFTP Contmatic</title>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<meta charset="UTF-8">
		<link href="/css/bootstrap.min.css" rel="stylesheet">
		<style>
		body {
		  background-image: url('/img/sky.jpg');
		  background-repeat: no-repeat;
		  background-attachment: fixed;
		  background-size: 100% 100%;
			 }
		</style>
	</head>
	<body>

		<div class="container" style="margin-top: 50px">

					  <form method="post" action="index.php">
								<h3 class="container" >Preencha abaixo e selecione uma opção<br><br>
								<label for="numerocliente">Código do cliente (obrigatório):</label><br>
								<input name="numerocliente" type="text" class="form-control" style="width: 150px; display: inline" autocomplete="off" /><br><br>
								
								<label for="aliascliente">Nome do cliente (opcional):</label><br>
								<input name="aliascliente" type="text" class="form-control" style="width: 150px; display: inline" autocomplete="off" /><br><br>
								<input name="submit" type="submit" value="Gerar SFTP" class="btn btn-primary" />
								<input name="submit2" type="submit" value="Reset de Senha" class="btn btn-primary" />

		              </form>
		<div class="container1" style="margin-top: 30px ">
			<?php
				
				$fname = $_POST['numerocliente'];

				if(isset($_POST['submit']))
				{
					shell_exec("/var/www/html/gerarftp/application/verify.sh $fname");
					$codigoexiste = shell_exec('cat /var/www/html/gerarftp/application/usuario');
					
					if(is_numeric($_POST['numerocliente']) )

					{	$confere = (int) $fname;
						$confere2 = (int) $codigoexiste;
						if ($confere == $confere2)
						
						{
							echo "<h3>Código SFTP já criado, crie um novo ou resete a senha";
						}
						
						elseif  ($confere != $confere2)
						
						{
						shell_exec("/var/www/html/gerarftp/application/ftp.sh $fname");
						$senha = shell_exec('cat /var/www/html/gerarftp/application/kid7ehabayffeay');
						echo "<h3> FTP Seguro gerado com sucesso:";
						echo "<h3>SFTP";
						echo "<h3>{$_POST['numerocliente']} ({$_POST['aliascliente']})";
						echo "<h3>Host:168.138.137.231";
						echo "<h3>Porta:22/tcp";
						echo "<h3>User:cmatic-sftp-{$_POST['numerocliente']}";
						echo "<h3>Senha:$senha";
						echo "<h3><br>";

					    } else {
						
						echo "<h3>Informe o Código do Cliente<br>";
						echo '';
						
					
					           }
				    }
				}


				if(isset($_POST['submit2']))
				{	
					shell_exec("/var/www/html/gerarftp/application/verify.sh $fname");
					$codigoexiste = shell_exec('cat /var/www/html/gerarftp/application/usuario');
					
					if(is_numeric($_POST['numerocliente']) )

					{	$confere = (int) $fname;
						$confere2 = (int) $codigoexiste;
						if ($confere != $confere2)
						
						{
							echo "<h3>Código SFTP não encontrado";
						}
						
						elseif  ($confere == $confere2)
						
						{

						shell_exec("/var/www/html/gerarftp/application/senha.sh $fname");
						$senha = shell_exec('cat /var/www/html/gerarftp/application/kid7ehabayffeay');

						echo "<h3> Senha resetada:";
						echo "<h3>SFTP";
						echo "<h3>{$_POST['numerocliente']} ({$_POST['aliascliente']})";
						echo "<h3>Host:168.138.137.231";
						echo "<h3>Porta:22/tcp";
						echo "<h3>User:cmatic-sftp-{$_POST['numerocliente']}";
						echo "<h3>Nova Senha:$senha";
						echo "<h3><br>";

					} else {
						
						echo "<h3>Informe o Código do Cliente<br>";
						echo '';
						
					
						   }
				    }
				}
				
			?>
		  


	       </div>
		</div>
	
	</body>
</html>