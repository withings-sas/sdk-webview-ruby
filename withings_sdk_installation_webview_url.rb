require 'base64'
require 'json'
require 'openssl'
require 'active_support/all'

class User
	def initialize(first_name:, email:, birthdate:, external_id:)
    @first_name  = first_name
    @email       = email
		@birthdate   = birthdate
		# Used to identify the user when Withings POSTs OAuth tokens back to redirect_uri
		@external_id = external_id
  end

	def email
		@email
	end

	def first_name
		@first_name
	end

	def birthdate
		@birthdate
	end

	def external_id
		@external_id
	end

end


class WithingsSDKInstallationWebviewUrl
	REDIRECT_URI = 'https://www.my-domain.com/';
  WITHINGS_BODY_MODEL = 7
  WITHINGS_LBS_PREFERENCE = 2
  WITHINGS_INCHES_HEIGHT_PREFERENCE = 7
  WITHINGS_YARDS_DISTANCE_PREFERENCE = 8
  WITHINGS_FAHRENHEIT_PREFERENCE = 13

	#
	# Example for Rails
	#

  def initialize(user)
    @user = user
  end

  def withings_webview_url(height_ft:, height_in:, weight_lbs:)
    @height_ft = height_ft
    @height_in = height_in
    @weight_lbs = weight_lbs
    base_withings_webview_url + '?' + params.to_query
  end

  private

  attr_reader :user

  def base_withings_webview_url
    'https://account.withings.com/sdk/sdk_init'
  end

  def client_id
    ENV['WITHINGS_CLIENT_ID']
  end

  def params
    signature_params.merge(
      model: WITHINGS_BODY_MODEL,
      signature: signature,
    )
  end

  def signature_params
    @signature_params ||= {
      client_id: client_id,
      cryptbirthdate: encrypted_birthdate,
      cryptmeasures: encrypted_measures,
      external_id: user.external_id,
      gender: 1,
      iv: iv,
      preflang: 'en_US',
      redirect_uri: REDIRECT_URI,
      shortname: (user.first_name || user.email)[0...3].upcase,
      unit_pref: {
        weight: WITHINGS_LBS_PREFERENCE,
        height: WITHINGS_INCHES_HEIGHT_PREFERENCE,
        distance: WITHINGS_YARDS_DISTANCE_PREFERENCE,
        temperature: WITHINGS_FAHRENHEIT_PREFERENCE,
      }.to_s,
    }
  end


  def signature
    unhashed_signature = signature_params.keys.sort.map { |key| signature_params[key] }.join(',')
    OpenSSL::HMAC.hexdigest('SHA256', ENV['WITHINGS_CONSUMER_SECRET'], unhashed_signature)
  end

  def encrypted_birthdate
    @encrypted_birthdate ||= begin
      cipher = new_cipher
      Base64.strict_encode64(
        cipher.update(user.birthdate.to_i.to_s) + cipher.final
      )
    end
  end

  def encrypted_measures
    @encrypted_measures ||= begin
      cipher = new_cipher
      Base64.strict_encode64(
        cipher.update(measures.to_json) + cipher.final
      )
    end
  end

  def height_measures
    {
      value: ((@height_ft / 3.28084 + @height_in / 39.3701) * 100).round,
      unit: -2,
      type: 4,
    }
  end

  def weight_measures
    {
      value: (@weight_lbs / 2.20462 * 100).round,
      unit: -2,
      type: 1,
    }
  end

  def measures
    [height_measures, weight_measures]
  end

  def iv
    @iv ||= _new_cipher.random_iv
  end

  def new_cipher
    cipher = _new_cipher
    cipher.iv = iv
    cipher.key = key
    cipher
  end

  def _new_cipher
    cipher = OpenSSL::Cipher::AES.new(256, :CTR)
    cipher.encrypt
    cipher
  end

  def key
    ENV['WITHINGS_CONSUMER_SECRET'][0...32]
  end
end

#
# Replace the place holder {{}} with your information
# birthdate format : yyyy-mm-dd
# external_id : Partner end-user unique identifier
#

user = User.new(first_name: "{{first_name}}", email: "{{email}}", birthdate: {{birthdate}}, external_id: {{external_id}})
c = WithingsSDKInstallationWebviewUrl.new(user)
puts c.withings_webview_url(height_ft: {{height_ft}}, height_in: {{height_in}}, weight_lbs: {{weight_lbs}})
