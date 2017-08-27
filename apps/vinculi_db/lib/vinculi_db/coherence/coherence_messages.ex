defmodule VinculiDb.Coherence.Messages do
  @moduledoc """
  Application facing messages generated by the Coherence application.

  This module was created by the coh.install mix task. It contains all the
  messages used in the coherence application except those in other generated
  files like the view and templates.

  To assist in upgrading Coherence, the `Coherence.Messages behaviour will
  alway contain every message for the current version.  This will help in upgrades
  to ensure the user had added new the new messages from the current version.

  IMPORTANT:
  VinculiDb is an access to database, therefore, message should nopt be
  trnaslated here but in the world-facing app
  """
  @behaviour Coherence.Messages

  # import VinculiWeb.Gettext

  # Change this to override the "coherence" gettext domain. If you would like
  # the coherence message to be part of your projects domain change it to "default"
  # @domain "coherence"

  ##################
  # Messages

  def account_already_confirmed, do: "Account already confirmed."
  def account_is_not_locked, do: "Account is not locked."
  def account_updated_successfully, do: "Account updated successfully."
  def already_confirmed, do: "already confirmed"
  def already_locked, do: "already locked"
  def already_logged_in, do: "Already logged in."
  def cant_be_blank, do: "can't be blank"
  def cant_find_that_token, do: "Can't find that token"
  def confirmation_email_sent, do: "Confirmation email sent."
  def confirmation_token_expired, do: "Confirmation token expired."
  def could_not_find_that_email_address, do: "Could not find that email address"
  def forgot_your_password, do: "Forgot your password?"
  def http_authentication_required, do: "HTTP Authentication Required"
  def incorrect_login_or_password(opts), do: "Incorrect #{opts["login_field"]} or password."
  def invalid_current_password, do: "invalid current password"
  def invalid_invitation, do: "Invalid Invitation. Please contact the site administrator."
  def invalid_request, do: "Invalid Request."
  def invalid_confirmation_token, do: "Invalid confirmation token."
  def invalid_email_or_password, do: "Invalid email or password."
  def invalid_invitation_token, do: "Invalid invitation token."
  def invalid_reset_token, do: "Invalid reset token."
  def invalid_unlock_token, do: "Invalid unlock token."
  def invitation_already_sent, do: "Invitation already sent."
  def invitation_sent, do: "Invitation sent."
  def invite_someone, do: "Invite Someone"
  def maximum_login_attempts_exceeded, do: "Maximum Login attempts exceeded. Your account has been locked."
  def need_an_account, do: "Need An Account?"
  def not_locked, do: "not locked"
  def password_reset_token_expired, do: "Password reset token expired."
  def password_updated_successfully, do: "Password updated successfully."
  def problem_confirming_user_account, do: "Problem confirming user account. Please contact the system administrator."
  def registration_created_successfully, do: "Registration created successfully."
  def required, do: "required"
  def resend_confirmation_email, do: "Resend confirmation email"
  def reset_email_sent, do: "Reset email sent. Check your email for a reset link."
  def restricted_area, do: "Restricted Area"
  def send_an_unlock_email, do: "Send an unlock email"
  def sign_in, do: "Sign In"
  def sign_out, do: "Sign Out"
  def signed_in_successfully, do: "Signed in successfully."
  def too_many_failed_login_attempts, do: "Too many failed login attempts. Account has been locked."
  def unauthorized_ip_address, do: "Unauthorized IP Address"
  def unlock_instructions_sent, do: "Unlock Instructions sent."
  def user_account_confirmed_successfully, do: "User account confirmed successfully."
  def user_already_has_an_account, do: "User already has an account!"
  def you_must_confirm_your_account, do: "You must confirm your account before you can login."
  def your_account_has_been_unlocked, do: "Your account has been unlocked"
  def your_account_is_not_locked, do: "Your account is not locked."
  def verify_user_token(opts), do: "Invalid #{opts["user_token"]} error: #{opts["error"]}"
  def you_are_using_an_invalid_security_token,
    do: "You are using an invalid security token for this site! This security\n" <>
      "violation has been logged.\n"
  def mailer_required, do: "Mailer configuration required!"
  def account_is_inactive(), do: "Account is inactive!"
end