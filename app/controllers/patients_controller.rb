class PatientsController < ApplicationController
    get '/patients' do
        "Show list of patients"
    end

    get '/patients/new' do
        #check to see if user is logged in
        if !logged_in?
            redirect "/login"
        else
            "Create a new patient record form"
        end
    end

    get '/patients/:id/edit' do
        #check to see if user logged in

        if !logged_in?
            redirect "/login"
        else
            #Ensure only logged in user is allowed to edit => USER OBJECT
            
            if patient = current_user.patients.find_by(params[:id])
                "User ID #{current_user.id} is editing patient ID #{patient.id}"
            else
                redirect '/patients'
            end
        end
    end
end
