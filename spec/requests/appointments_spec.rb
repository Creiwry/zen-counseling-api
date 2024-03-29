# frozen_string_literal: true

require 'rails_helper'

# # This spec was generated by rspec-rails when you ran the scaffold generator.
# # It demonstrates how one might use RSpec to test the controller code that
# # was generated by Rails when you ran the scaffold generator.
# #
# # It assumes that the implementation code is generated by the rails scaffold
# # generator. If you are using any extension libraries to generate different
# # controller code, this generated spec may or may not pass.
# #
# # It only uses APIs available in rails and/or rspec-rails. There are a number
# # of tools you can use to make these specs even more expressive, but we're
# # sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe '/appointments', type: :request do
  let(:correct_user) do
    User.create!(
      email: 'user@example.com',
      password: 'Password!23',
      admin: false,
      first_name: 'Billie Joe',
      last_name: 'Armstrong',
      full_name: 'Billie Joe Armstrong'
    )
  end

  let(:incorrect_user) do
    User.create!(
      email: 'user2@example.com',
      password: 'Password!23',
      admin: false,
      first_name: 'John',
      last_name: 'Smith',
      full_name: 'Billie Joe Armstrong'
    )
  end

  let(:admin) do
    User.create!(
      email: 'admin@example.com',
      password: 'Password!23',
      admin: true,
      first_name: 'Gerard',
      last_name: 'Way',
      full_name: 'Gerard Arthur Way'
    )
  end

  let!(:invoice) { create(:invoice, client: correct_user, admin:, status: 'paid') }

  let(:valid_attributes) do
    {
      appointment: {
        client: correct_user,
        admin:,
        datetime: DateTime.now + 3.days,
        link: 'https://zoom.us/my_link',
        status: 'available'
      }
    }
  end

  let(:invalid_attributes) do
    {
      appointment: {
        client: correct_user,
        admin:,
        datetime: DateTime.now + 3.days
      },
      link: 'this_is_the_link',
      status: 'available'
    }
  end

  let(:sql_injection_attributes) do
    {
      appointment: {
        client: correct_user,
        admin:,
        datetime: DateTime.now + 3.days,
        link: "admin'; DROP TABLE users;--",
        status: 'available'

      }
    }
  end

  let(:cross_site_scripting_attributes) do
    {
      appointment: {
        client: correct_user,
        admin:,
        datetime: DateTime.now + 3.days,
        link: "<script>alert('XSS attack');</script>",
        status: 'available'

      }
    }
  end

  describe 'GET /users/:user_id/appointments' do
    context 'when unauthenticated' do
      it 'returns an unauthenticated response' do
        get user_appointments_path(user_id: correct_user.id)
        expect(response).to be_unauthorized
      end
    end

    context 'when authenticated' do
      context 'when not the relevant user or admin' do
        before do
          post '/users/sign_in', params: {
            user: {
              email: incorrect_user.email,
              password: 'Password!23'
            }
          }
          @token = response.headers['authorization']
        end

        it 'returns an unauthorized response' do
          get user_appointments_path(user_id: correct_user.id), headers: { Authorization: @token }
          expect(response).to be_unauthorized
        end
      end

      context 'when the relevant user' do
        before do
          post '/users/sign_in', params: {
            user: {
              email: correct_user.email,
              password: 'Password!23'
            }
          }
          @token = response.headers['authorization']
        end

        it 'returns a successful response' do
          get user_appointments_path(user_id: correct_user.id), headers: { Authorization: @token }
          expect(response).to be_successful
        end
      end

      context 'when admin' do
        before do
          post '/users/sign_in', params: {
            user: {
              email: admin.email,
              password: 'Password!23'
            }
          }
          @token = response.headers['authorization']
        end

        it 'returns a successful response' do
          get user_appointments_path(user_id: correct_user.id), headers: { Authorization: @token }
          expect(response).to be_successful
        end
      end
    end
  end

  describe 'GET /users/:user_id/appointments/:id' do
    context 'when unauthenticated' do
      let!(:appointment) { create(:appointment, client: correct_user, admin:) }

      it 'returns an unauthenticated response' do
        get user_appointments_path(user_id: correct_user.id, id: appointment.id)
        expect(response).to be_unauthorized
      end
    end

    context 'when authenticated' do
      context 'when not the relevant user or admin' do
        let!(:appointment) { create(:appointment, client: correct_user, admin:) }

        before do
          post '/users/sign_in', params: {
            user: {
              email: incorrect_user.email,
              password: 'Password!23'
            }
          }
          @token = response.headers['authorization']
        end

        it 'returns an unauthorized response' do
          get user_appointments_path(user_id: correct_user.id, id: appointment.id), headers: { Authorization: @token }
          expect(response).to be_unauthorized
        end
      end

      context 'when the relevant user' do
        let!(:appointment) { create(:appointment, client: correct_user, admin:) }

        before do
          post '/users/sign_in', params: {
            user: {
              email: correct_user.email,
              password: 'Password!23'
            }
          }
          @token = response.headers['authorization']
        end

        it 'returns a successful response' do
          get user_appointments_path(user_id: correct_user.id, id: appointment.id), headers: { Authorization: @token }
          expect(response).to be_successful
        end
      end

      context 'when admin' do
        let!(:appointment) { create(:appointment, client: correct_user, admin:) }

        before do
          post '/users/sign_in', params: {
            user: {
              email: admin.email,
              password: 'Password!23'
            }
          }
          @token = response.headers['authorization']
        end

        it 'returns a successful response' do
          get user_appointments_path(user_id: correct_user.id, id: appointment.id), headers: { Authorization: @token }
          expect(response).to be_successful
        end
      end
    end
  end

  describe 'GET /confirmed_appointments' do
    context 'when unauthenticated' do
      let!(:appointment) { create(:appointment, client: correct_user, admin:, status: 'confirmed') }

      it 'returns an unauthenticated response' do
        get confirmed_appointments_path
        expect(response).to be_unauthorized
      end
    end

    context 'when authenticated' do
      let!(:appointment) { create(:appointment, client: correct_user, admin:, status: 'confirmed') }

      before do
        post '/users/sign_in', params: {
          user: {
            email: correct_user.email,
            password: 'Password!23'
          }
        }
        @token = response.headers['authorization']
      end

      it 'returns a successful response' do
        get confirmed_appointments_path, headers: { Authorization: @token }
        expect(response).to be_successful
      end

      context 'if user signed in' do
        before do
          post '/users/sign_in', params: {
            user: {
              email: correct_user.email,
              password: 'Password!23'
            }
          }
          @token = response.headers['authorization']
        end

        it 'returns data for current user' do
          get confirmed_appointments_path, headers: { Authorization: @token }

          user_appointments = correct_user.client_appointments.where(status: 'confirmed')
          user_appointments = user_appointments.map(&:to_json)
          other_apppointments = create_list(:appointment, 2).map(&:to_json)

          response_appointments = response.parsed_body['data'].map(&:to_json)

          expect(response_appointments).to match_array(user_appointments)
          expect(response_appointments).not_to include(*other_apppointments)
        end
      end

      context 'if admin signed in' do
        before do
          post '/users/sign_in', params: {
            user: {
              email: admin.email,
              password: 'Password!23'
            }
          }
          @token = response.headers['authorization']
        end

        it 'returns data for admin' do
          get confirmed_appointments_path, headers: { Authorization: @token }

          admin_appointments = admin.admin_appointments.where(status: 'confirmed').map(&:to_json)
          other_apppointments = create_list(:appointment, 2).map(&:to_json)
          response_appointments = response.parsed_body['data'].map(&:to_json)

          expect(response_appointments).to match_array(admin_appointments)
          expect(response_appointments).not_to include(*other_apppointments)
        end
      end
    end
  end

  describe 'GET /pending_appointments' do
    context 'when unauthenticated' do
      let!(:appointment) { create(:appointment, client: correct_user, admin:, status: 'unconfirmed') }

      it 'returns an unauthenticated response' do
        get pending_appointments_path
        expect(response).to be_unauthorized
      end
    end

    context 'when authenticated' do
      let!(:appointment) { create(:appointment, client: correct_user, admin:, status: 'unconfirmed') }

      context 'when client signed in' do
        before do
          post '/users/sign_in', params: {
            user: {
              email: correct_user.email,
              password: 'Password!23'
            }
          }
          @token = response.headers['authorization']
        end

        it 'returns an unauthorized response' do
          get pending_appointments_path, headers: { Authorization: @token }
          expect(response).to be_unauthorized
        end
      end

      context 'when admin signed in' do
        before do
          post '/users/sign_in', params: {
            user: {
              email: admin.email,
              password: 'Password!23'
            }
          }
          @token = response.headers['authorization']
        end

        it 'returns a successful response' do
          get pending_appointments_path, headers: { Authorization: @token }
          expect(response).to be_successful
        end

        it 'returns data for admin' do
          get pending_appointments_path, headers: { Authorization: @token }

          admin_appointments = admin.admin_appointments.where(status: 'unconfirmed').map(&:to_json)
          other_apppointments = create_list(:appointment, 2).map(&:to_json)
          response_appointments = response.parsed_body['data'].map(&:to_json)

          expect(response_appointments).to match_array(admin_appointments)
          expect(response_appointments).not_to include(*other_apppointments)
        end
      end
    end
  end

  describe 'GET /available_appointment' do
    context 'when unauthenticated' do
      let!(:appointment) { create(:appointment, client: correct_user, admin:, status: 'available') }

      it 'returns an unauthenticated response' do
        get available_appointment_path
        expect(response).to be_unauthorized
      end
    end

    context 'when authenticated client' do
      let!(:appointment) { create(:appointment, client: correct_user, admin:, status: 'available') }

      before do
        post '/users/sign_in', params: {
          user: {
            email: correct_user.email,
            password: 'Password!23'
          }
        }
        @token = response.headers['authorization']
      end

      it 'returns a successful response' do
        get available_appointment_path, headers: { Authorization: @token }
        expect(response).to be_successful
      end

      it 'returns a single available appointment' do
        get available_appointment_path, headers: { Authorization: @token }
        my_response = response

        last_appointment = correct_user.available_appointment.to_json

        expect(my_response.parsed_body['data'].to_json).to eq(last_appointment)
      end
    end

    context 'if admin signed in' do
      before do
        post '/users/sign_in', params: {
          user: {
            email: admin.email,
            password: 'Password!23'
          }
        }
        @token = response.headers['authorization']
      end

      it 'returns message resource not found' do
        get available_appointment_path, headers: { Authorization: @token }

        expect(response.parsed_body['status']['message']).to eq('resource not found')
      end
    end
  end

  describe 'GET /users/:user_id/appointments/by_date/:appointment_date' do
    context 'when unauthenticated' do
      let!(:appointment) do
        create(:appointment, client: correct_user, admin:, status: 'confirmed', datetime: DateTime.now + 3.days)
      end

      it 'returns an unauthenticated response' do
        get "/users/#{correct_user.id}/appointments/by_date/08-01-2024"
        expect(response).to be_unauthorized
      end
    end

    context 'when authenticated' do
      let!(:appointment) do
        create(:appointment, client: correct_user, admin:, status: 'confirmed', datetime: DateTime.now + 3.days)
      end

      context 'when correct client signed in' do
        before do
          post '/users/sign_in', params: {
            user: {
              email: correct_user.email,
              password: 'Password!23'
            }
          }
          @token = response.headers['authorization']
        end

        it 'returns a successful response' do
          get "/users/#{correct_user.id}/appointments/by_date/08-01-2024", headers: { Authorization: @token }
          expect(response).to be_successful
        end

        it 'returns data for client', focus: true do
          get "/users/#{correct_user.id}/appointments/by_date/15-05-2024", headers: { Authorization: @token }

          client_appointments = correct_user.client_appointments
                                            .where(status: 'confirmed')
                                            .filter_based_on_date('15-05-2024'.to_date)
                                            .map { |appointment| appointment.attach_information_of_other_user('client').to_json }

          other_apppointments = create_list(:appointment, 2).map(&:to_json)
          response_appointments = response.parsed_body['data'].map(&:to_json)

          expect(response_appointments).to match_array(client_appointments)
          expect(response_appointments).not_to include(*other_apppointments)
        end
      end

      context 'when incorrect client signed in' do
        before do
          post '/users/sign_in', params: {
            user: {
              email: incorrect_user.email,
              password: 'Password!23'
            }
          }
          @token = response.headers['authorization']
        end

        it 'returns an unauthorized response' do
          get "/users/#{correct_user.id}/appointments/by_date/08-01-2024", headers: { Authorization: @token }
          expect(response).to be_unauthorized
        end
      end

      context 'when admin signed in' do
        before do
          post '/users/sign_in', params: {
            user: {
              email: admin.email,
              password: 'Password!23'
            }
          }
          @token = response.headers['authorization']
        end

        it 'returns a successful response' do
          get "/users/#{correct_user.id}/appointments/by_date/08-01-2024", headers: { Authorization: @token }
          expect(response).to be_successful
        end

        it 'returns data for admin', focus: true do
          get "/users/#{correct_user.id}/appointments/by_date/15-05-2024", headers: { Authorization: @token }

          admin_appointments = admin.admin_appointments
                                    .where(status: 'confirmed')
                                    .filter_based_on_date('15-05-2024'.to_date)
                                    .map { |appointment| appointment.attach_information_of_other_user('admin').to_json }

          other_apppointments = create_list(:appointment, 2).map(&:to_json)
          response_appointments = response.parsed_body['data'].map(&:to_json)

          expect(response_appointments).to match_array(admin_appointments)
          expect(response_appointments).not_to include(*other_apppointments)
        end
      end
    end
  end

  describe 'PATCH /users/:user_id/appointments' do
    context 'when unauthenticated' do
      let!(:appointment) { create(:appointment, client: correct_user, admin:, status: 'confirmed') }

      it 'returns an unauthenticated response' do
        patch user_appointment_path(user_id: correct_user.id, id: appointment.id), params: valid_attributes
        expect(response).to be_unauthorized
      end

      context 'when sql injection attributes are sent' do
        it 'returns an unauthenticated response' do
          patch user_appointment_path(user_id: correct_user.id, id: appointment.id), params: sql_injection_attributes
          expect(response).to be_unauthorized
        end
      end

      context 'when cross site scription attributes are sent' do
        it 'returns an unauthenticated response' do
          patch user_appointment_path(user_id: correct_user.id, id: appointment.id),
                params: cross_site_scripting_attributes
          expect(response).to be_unauthorized
        end
      end
    end

    context 'when authenticated' do
      let!(:appointment) { create(:appointment, client: correct_user, admin:, status: 'confirmed') }
      context 'when not the relevant user or admin' do
        before do
          post '/users/sign_in', params: {
            user: {
              email: incorrect_user.email,
              password: 'Password!23'
            }
          }
          @token = response.headers['authorization']
        end

        it 'returns an unauthorized response' do
          patch user_appointment_path(user_id: correct_user.id, id: appointment.id), params: valid_attributes,
                                                                                     headers: { Authorization: @token }
          expect(response).to be_unauthorized
        end

        context 'when sql injection attributes are sent' do
          it 'returns an unauthenticated response' do
            patch user_appointment_path(user_id: correct_user.id, id: appointment.id),
                  params: sql_injection_attributes, headers: { Authorization: @token }
            expect(response).to be_unauthorized
          end
        end

        context 'when cross site scription attributes are sent' do
          it 'returns an unauthenticated response' do
            patch user_appointment_path(user_id: correct_user.id, id: appointment.id),
                  params: cross_site_scripting_attributes, headers: { Authorization: @token }
            expect(response).to be_unauthorized
          end
        end
      end

      context 'when the relevant user or admin' do
        let!(:appointment) { create(:appointment, client: correct_user, admin:, status: 'confirmed') }
        before do
          post '/users/sign_in', params: {
            user: {
              email: correct_user.email,
              password: 'Password!23'
            }
          }
          @token = response.headers['authorization']
        end

        it 'returns a successful response' do
          patch user_appointment_path(user_id: correct_user.id, id: appointment.id), params: valid_attributes,
                                                                                     headers: { Authorization: @token }
          expect(response).to be_successful
        end

        context 'when sql injection attributes are sent as link' do
          it 'returns a bad request response' do
            patch user_appointment_path(user_id: correct_user.id, id: appointment.id),
                  params: sql_injection_attributes, headers: { Authorization: @token }
            expect(response.status).to eq(422)
          end
        end

        context 'when cross site scription attributes are sent as link' do
          it 'returns a bad request response' do
            patch user_appointment_path(user_id: correct_user.id, id: appointment.id),
                  params: cross_site_scripting_attributes, headers: { Authorization: @token }
            expect(response.status).to eq(422)
          end
        end
      end
    end
  end

  describe 'DELETE /users/:user_id/appointments/:id' do
    context 'when unauthenticated' do
      let!(:appointment) { create(:appointment, client: correct_user, admin:, status: 'past') }

      it 'returns an unauthenticated response' do
        delete user_appointment_path(user_id: correct_user.id, id: appointment.id)
        expect(response).to be_unauthorized
      end
    end

    context 'when authenticated' do
      context 'when not the relevant user or admin' do
        let!(:appointment) { create(:appointment, client: correct_user, admin:, status: 'past') }
        before do
          post '/users/sign_in', params: {
            user: {
              email: incorrect_user.email,
              password: 'Password!23'
            }
          }
          @token = response.headers['authorization']
        end

        it 'returns an unauthorized response' do
          delete user_appointment_path(user_id: correct_user.id, id: appointment.id), headers: { Authorization: @token }
          expect(response).to be_unauthorized
        end
      end

      context 'when the relevant user' do
        let!(:appointment) { create(:appointment, client: correct_user, admin:, status: 'past') }
        before do
          post '/users/sign_in', params: {
            user: {
              email: correct_user.email,
              password: 'Password!23'
            }
          }
          @token = response.headers['authorization']
        end

        it 'returns an unauthorized response' do
          delete user_appointment_path(user_id: correct_user.id, id: appointment.id), headers: { Authorization: @token }
          expect(response).to be_unauthorized
        end
      end

      context 'when admin' do
        let!(:appointment) { create(:appointment, client: correct_user, admin:, status: 'past') }
        before do
          post '/users/sign_in', params: {
            user: {
              email: admin.email,
              password: 'Password!23'
            }
          }
          @token = response.headers['authorization']
        end

        it 'returns a successful response' do
          delete user_appointment_path(user_id: correct_user.id, id: appointment.id), headers: { Authorization: @token }
          expect(response).to be_successful
        end
      end
    end
  end
end
