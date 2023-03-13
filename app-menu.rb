#Linked list
$menus = {
    1 => {
        name: "Sign Up",
        instructions: "Please provide the following info",
        action: "sign_up",
        requests:[
            {
                request: "Enter your name: ",
                field: "name"
            },
            {
                request: "Enter your phone number: ",
                field: "phone"
            },
            {
                request: "Select a pin number: ",
                field: "pin"
            },
            {
                request: "Verify your pin",
                field: "verified_pin",
                action: "verify_pin"
            }
        ]
    },

    2 => {
        name: "Deposit",
        instructions: "You can deposit straight from your M-Pesa",
        action: "deposit",
        requests:[
            {
                request: "Enter your phone number: ",
                field: "phone"
            },
            {
                request: "Enter your pin: ",
                field: "pin",
                action: "sign_in"
            },
            {
                request: "Enter amount to deposit: ",
                field: "amount"
            }
        ]
    },

    3 => {
        name: "Check Balance",
        instructions: "Provide the following info",
        action: "check_balance",
        requests:[
            {
                request: "Enter your phone number: ",
                field: "phone"
            },
            {
                request: "Enter your pin: ",
                field: "pin",
                action: "sign_in"
            }
        ]
    },

    4 => {
        name:"Request statement",
        instructions: "Select duration",
        options:{
            1 => {
                name: "Last 1 month",
                action: "statement"
            },
            2 => {
                name: "Last 3 months",
                action: "statement"
            },
            3 => {
                name: "Last 6 months",
                action: "statement"
            }
        }
    }

}