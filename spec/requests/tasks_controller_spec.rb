require 'rails_helper'

describe 'GET /api/v1/tasks' do
    scenario 'List all with success' do
        # First we get a token
        post '/api/v1/sessions', params: {
            email: 'foo@example.com',
            password: 'foopasswd'
        }

        expect(response.status).to eq(201)
        response_body = JSON.parse(response.body);
        expect(response_body['logged_in']).to eq(true)
        expect(response_body['user']['email']).to eq('foo@example.com')
        user_id = response_body['user']['id']
        jwt = response_body['jwt']

        # Now we try to list the tasks
        get '/api/v1/tasks', headers: {'Authorization' => jwt}

        expect(response.status).to eq(200)
        tasks = JSON.parse(response.body)
        expect(tasks['status']).to eq('SUCCESS')
        # Check the invariants, it must either list the ones that are public or the ones that are
        # ours (or both)
        expect(tasks['data'].empty? || tasks['data'].all? { 
            |task| task['visibility'] == 'public' || task['owner'] == user_id
        }).to eq(true)
    end

    scenario 'List only public' do
        # First we get a token
        post '/api/v1/sessions', params: {
            email: 'foo@example.com',
            password: 'foopasswd'
        }

        expect(response.status).to eq(201)
        response_body = JSON.parse(response.body);
        expect(response_body['logged_in']).to eq(true)
        expect(response_body['user']['email']).to eq('foo@example.com')
        user_id = response_body['user']['id']
        jwt = response_body['jwt']

        # Now we try to list the tasks
        get '/api/v1/tasks', headers: {'Authorization' => jwt}, params: {
            with_visibility: 'public'
        }

        expect(response.status).to eq(200)
        tasks = JSON.parse(response.body)
        expect(tasks['status']).to eq('SUCCESS')
        # Check the invariants
        expect(tasks['data'].empty? || tasks['data'].all? { 
            |task| task['visibility'] == 'public'
        }).to eq(true)
    end

    scenario 'List only private' do
        # First we get a token
        post '/api/v1/sessions', params: {
            email: 'foo@example.com',
            password: 'foopasswd'
        }

        expect(response.status).to eq(201)
        response_body = JSON.parse(response.body);
        expect(response_body['logged_in']).to eq(true)
        expect(response_body['user']['email']).to eq('foo@example.com')
        user_id = response_body['user']['id']
        jwt = response_body['jwt']

        # Now we try to list the tasks
        get '/api/v1/tasks', headers: {'Authorization' => jwt}, params: {
            with_visibility: 'private'
        }

        expect(response.status).to eq(200)
        tasks = JSON.parse(response.body)
        expect(tasks['status']).to eq('SUCCESS')
        # Check the invariants
        expect(tasks['data'].empty? || tasks['data'].all? { 
            |task| task['visibility'] == 'private' && task['owner'] == user_id
        }).to eq(true)
    end

    scenario 'List only done' do
        # First we get a token
        post '/api/v1/sessions', params: {
            email: 'foo@example.com',
            password: 'foopasswd'
        }

        expect(response.status).to eq(201)
        response_body = JSON.parse(response.body);
        expect(response_body['logged_in']).to eq(true)
        expect(response_body['user']['email']).to eq('foo@example.com')
        user_id = response_body['user']['id']
        jwt = response_body['jwt']

        # Now we try to list the tasks
        get '/api/v1/tasks', headers: {'Authorization' => jwt}, params: {
            with_status: 'done'
        }

        expect(response.status).to eq(200)
        tasks = JSON.parse(response.body)
        expect(tasks['status']).to eq('SUCCESS')
        # Check the invariants
        expect(tasks['data'].empty? || tasks['data'].all? { 
            |task| task['status'] == 'done' && (task['visibility'] == 'public' || task['owner'] == user_id)
        }).to eq(true)
    end

    scenario 'List only pending' do
        # First we get a token
        post '/api/v1/sessions', params: {
            email: 'foo@example.com',
            password: 'foopasswd'
        }

        expect(response.status).to eq(201)
        response_body = JSON.parse(response.body);
        expect(response_body['logged_in']).to eq(true)
        expect(response_body['user']['email']).to eq('foo@example.com')
        user_id = response_body['user']['id']
        jwt = response_body['jwt']

        # Now we try to list the tasks
        get '/api/v1/tasks', headers: {'Authorization' => jwt}, params: {
            with_status: 'pending'
        }

        expect(response.status).to eq(200)
        tasks = JSON.parse(response.body)
        expect(tasks['status']).to eq('SUCCESS')
        # Check the invariants
        expect(tasks['data'].empty? || tasks['data'].all? { 
            |task| task['status'] == 'pending' && (task['visibility'] == 'public' || task['owner'] == user_id)
        }).to eq(true)
    end

    scenario 'No login is unauthorized' do
        # Now we try to list the tasks
        get '/api/v1/tasks'

        expect(response.status).to eq(401)
        tasks = JSON.parse(response.body)
        expect(tasks['status']).to eq('Error')
    end
end
