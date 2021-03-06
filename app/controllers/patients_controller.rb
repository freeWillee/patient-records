class PatientsController < ApplicationController
    get '/patients' do
        #check to see if logged in
        if logged_in?
            @user = current_user
            @patients = @user.patients.all
            @all_patients = Patient.all
            @all_users = User.all

            erb :"/patients/show.html"
        else
            @users = User.all
            @patients = Patient.all
            erb :"/patients/summary.html"
        end
    end

    get '/patients/new' do
        #check to see if user is logged in
        if !logged_in?
            redirect "/login"
        else
            erb :"/patients/new.html"
        end
    end

    get '/patients/:id' do
        if logged_in?
            @patient = current_user.patients.find_by(id: params[:id])
            if @patient
                @user = current_user
                @histories = @patient.histories

                erb :"/patients/unique_show.html"
            else
                redirect "/patients"
            end
        else
            redirect "/patients"
        end

    end
    
    post '/patients' do

        @patient = Patient.new
        @patient.name = params[:name]
        @patient.birth_year = params[:birth_year].to_i
        @patient.phone = params[:phone]
        @patient.address = params[:address]
        @patient.healthcarenumber = params[:healthcarenumber]
        @patient.user = User.find_by(id: current_user.id)

        if @patient.save
            redirect "/patients/#{@patient.id}"
        else
            erb :"patients/new.html"
        end
    end

    get '/patients/:id/edit' do
        #check to see if user logged in

        if !logged_in?
            redirect "/login"
        else
            #Ensure only logged in user is allowed to edit => USER OBJECT
            @patient = current_user.patients.find_by(id: params[:id].to_i)

            if @patient        
                
                erb :"/patients/edit.html"
            else
                redirect '/patients'
            end
        end
    end

    patch '/patients/:id/edit' do
        @patient = current_user.patients.find_by(id: params[:id])

        @patient.name = params[:name] if !params[:name].empty?
        @patient.birth_year = params[:birth_year].to_i if !params[:birth_year].empty?
        @patient.phone = params[:phone] if !params[:phone].empty?
        @patient.address = params[:address] if !params[:address].empty?
        @patient.healthcarenumber = params[:healthcarenumber] if !params[:healthcarenumber].empty?
        @patient.save

        redirect "/patients/#{@patient.id}"
    end

    delete '/patients/:id/delete' do
        @patient = current_user.patients.find_by(id: params[:id])
        @patient.histories.each do |history|
            history.delete
        end
        @patient.delete
        redirect '/patients'
    end
end
