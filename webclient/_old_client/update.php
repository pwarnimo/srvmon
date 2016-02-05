<?php
require_once "inc/init.php";

$user = new User();

if (!$user->isLoggedIn()) {
	Redirect::to("index.php");
}

if (Input::exists()) {
	if (Token::check(Input::get("token"))) {
		$validator = new Validator();
		$validation = $validator->check($_POST, array(
			"dtPasswordCurrent" => array(
				"required" => true
			),
			"dtPassword" => array(
				"required" => true,
				"min" => 6,
				"max" => 255
			),
			"dtPasswordAgain" => array(
				"required" => true,
				"min" => 6,
				"max" => 255,
				"matches" => "dtPassword"
			)
		));

		if ($validation->passed()) {
			if (Hash::make(Input::get("dtPasswordCurrent"), $user->data()->dtSalt) !== $user->data()->dtHash) {
				echo "Your current password is wrong!";
			}
			else {
				$salt = Hash::salt(32);
				$user->update(array(
					"dtHash" => Hash::make(Input::get("dtPassword"), $salt),
					"dtSalt" => $salt
				));

				Session::flash("home", "Your password has been updated!");
				Redirect::to("index.php");
			}
		}
		else {
			foreach ($validation->errors() as $error) {
				echo "<pre>" . $error . "</pre>";
			}
		}
	}
}

?>

<form action="" method="post">
	<div class="field">
		<label for="dtPasswordCurrent">Current Password</label>
		<input type="password" name="dtPasswordCurrent" id="dtPasswordCurrent">
		<label for="dtPassword">New Password</label>
		<input type="password" name="dtPassword" id="dtPassword">
		<label for="dtPasswordAgain">New Password Again</label>
		<input type="password" name="dtPasswordAgain" id="dtPasswordAgain">
		
		<input type="hidden" name="token" value="<?php echo Token::generate(); ?>">

		<input type="submit" value="Update">
	</div>
</form>
