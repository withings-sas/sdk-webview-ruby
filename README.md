This sample is an example of how to generate a Withings SDK installation webview url in ruby.
The full documentation of the Withings SDK is [here](http://developer.withings.com/sdk/)

# Quickstart

Before you get started, you'll need the following prerequisites:
* [A Withings account](https://account.withings.com/connectionuser/account_create)
* [A Withings developer app](https://account.withings.com/partner/account_login?b=add_oauth2)

Make sure you have installed Ruby before executing the script. Check [here](https://www.ruby-lang.org/en/documentation/installation/) if not.

# Running

You need to fill the place holder with your information.

* Line 183 :
```
user = User.new(first_name: "{{first_name}}", email: "{{email}}", birthdate: {{birthdate}}, external_id: {{external_id}})
```

* Line 185 :
```
puts c.withings_webview_url(height_ft: {{height_ft}}, height_in: {{height_in}}, weight_lbs: {{weight_lbs}})
```

You need to update the REDIRECT_URI constant at the beginning of the script.
```
REDIRECT_URI = 'https://www.my-domain.com/';
```

Before running the script, specify your client_id and client_secret you got from your developer account as environment variable in your console.
```
export WITHINGS_CLIENT_ID='{{WITHINGS_CLIENT_ID}}'
export WITHINGS_CONSUMER_SECRET='{{WITHINGS_CONSUMER_SECRET}}'
```
Don't forget to fill the place holder.

Run the script. The Withings SDK installation webview url will be generated.
```
ruby withings_sdk_installation_webview_url.rb
```

To remove the environnement variable from the shell, run these command lines.
```
unset WITHINGS_CLIENT_ID
unset WITHINGS_CONSUMER_SECRET
```

For any further information, don't hesitate to check our full documentation.
