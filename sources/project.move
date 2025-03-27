module MyModule::TutoringPayment {

    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    /// Struct representing a tutoring session.
    struct Session has store, key {
        tutor: address,
        rate_per_minute: u64,
    }

    /// Function to initialize a tutoring session with a rate per minute.
    public fun start_session(tutor: &signer, rate: u64) {
        let session = Session {
            tutor: signer::address_of(tutor),
            rate_per_minute: rate,
        };
        move_to(tutor, session);
    }

    /// Function to pay the tutor based on session duration in minutes.
    public fun pay_tutor(student: &signer, tutor_address: address, minutes: u64) acquires Session {
        let session = borrow_global<Session>(tutor_address);
        let amount = session.rate_per_minute * minutes;
        
        let payment = coin::withdraw<AptosCoin>(student, amount);
        coin::deposit<AptosCoin>(tutor_address, payment);
    }
}
