<?php

/* 📩 EMAIL DESTINO */
$dzEmailTo = "japrada28@gmail.com";
$dzEmailFrom = "Pediatra Bogotá";

function pr($value)
{
	echo "<pre>";
	print_r($value);
	echo "</pre>";
}

try {
    if (!empty($_POST)) {
		
		$dzRes = array('status' => 0, 'msg'=>'Something Went Wrong.');
		
		#### CONTACT FORM ####
		if($_POST['dzToDo'] == 'Contact')
		{
			$error = false;

			$dzName = !empty($_POST['dzName']) ? trim(strip_tags($_POST['dzName'])) : '';
			$dzEmail = !empty($_POST['dzEmail']) ? trim(strip_tags($_POST['dzEmail'])) : '';
			$dzMessage = !empty($_POST['dzMessage']) ? strip_tags($_POST['dzMessage']) : '';
			$dzPhoneNumber = !empty($_POST['dzPhoneNumber']) ? $_POST['dzPhoneNumber'] : '';

			if(empty($dzName)){
				$error = true;
				$msg = 'Please fill name.';
			}

			if(empty($dzEmail)){
				$error = true;
				$msg = 'Please enter email.';
			}else if (!filter_var($dzEmail, FILTER_VALIDATE_EMAIL)){
				$error = true;
				$msg = 'Wrong Email Format.';
			}

			if(empty($dzMessage)){
				$error = true;
				$msg = 'Please enter message.';
			}

			if ($error) {
				$dzRes['msg'] = $msg;
				echo json_encode($dzRes);
				exit;
			}

			$dzPhoneMessage = "";
			if(!empty($dzPhoneNumber)){
				$dzPhoneMessage = "Phone: $dzPhoneNumber <br/>";
			}

			$dzMailSubject = 'Nuevo lead - Pediatra Bogotá';
			$dzMailMessage = "
				<h3>Nuevo contacto</h3>
				Name: $dzName<br/>
				Email: $dzEmail<br/>
				$dzPhoneMessage
				Message: $dzMessage<br/>
			";

			$dzEmailHeader  = "MIME-Version: 1.0\r\n";
			$dzEmailHeader .= "Content-type: text/html; charset=UTF-8\r\n";
			$dzEmailHeader .= "From:$dzEmailFrom <$dzEmail>\r\n";
			$dzEmailHeader .= "Reply-To: $dzEmail\r\n";

			if(mail($dzEmailTo, $dzMailSubject, $dzMailMessage, $dzEmailHeader))
			{
				$dzRes['status'] = 1;
				$dzRes['msg'] = 'Mensaje enviado correctamente';
			}
			else
			{
				$dzRes['status'] = 0;
				$dzRes['msg'] = 'Error al enviar email';
			}

			echo json_encode($dzRes);
			exit;
		}

		#### APPOINTMENT FORM ####
		if($_POST['dzToDo'] == 'Appointment')
		{
			$error = false;

			$dzName = !empty($_POST['dzName']) ? trim(strip_tags($_POST['dzName'])) : '';
			$dzEmail = !empty($_POST['dzEmail']) ? trim(strip_tags($_POST['dzEmail'])) : '';
			$dzPhoneNumber = !empty($_POST['dzPhoneNumber']) ? $_POST['dzPhoneNumber'] : '';

			if(empty($dzName)){
				$error = true;
				$msg = 'Please fill name.';
			}

			if(empty($dzEmail)){
				$error = true;
				$msg = 'Please enter email.';
			}else if (!filter_var($dzEmail, FILTER_VALIDATE_EMAIL)){
				$error = true;
				$msg = 'Wrong Email Format.';
			}

			if ($error) {
				$dzRes['msg'] = $msg;
				echo json_encode($dzRes);
				exit;
			}

			$dzPhoneMessage = "";
			if(!empty($dzPhoneNumber)){
				$dzPhoneMessage = "Phone: $dzPhoneNumber <br/>";
			}

			$dzMailSubject = 'Nueva cita - Pediatra Bogotá';
			$dzMailMessage = "
				<h3>Solicitud de cita</h3>
				Name: $dzName<br/>
				Email: $dzEmail<br/>
				$dzPhoneMessage
			";

			$dzEmailHeader  = "MIME-Version: 1.0\r\n";
			$dzEmailHeader .= "Content-type: text/html; charset=UTF-8\r\n";
			$dzEmailHeader .= "From:$dzEmailFrom <$dzEmail>\r\n";
			$dzEmailHeader .= "Reply-To: $dzEmail\r\n";

			if(mail($dzEmailTo, $dzMailSubject, $dzMailMessage, $dzEmailHeader))
			{
				$dzRes['status'] = 1;
				$dzRes['msg'] = 'Cita enviada correctamente';
			}
			else
			{
				$dzRes['status'] = 0;
				$dzRes['msg'] = 'Error al enviar';
			}

			echo json_encode($dzRes);
			exit;
		}
	}
} catch (\Exception $e) {
    echo json_encode(['status' => 0, 'msg' => $e->getMessage()]);
    exit;
}