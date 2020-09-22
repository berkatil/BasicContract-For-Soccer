const SoccerContract = artifacts.require('SoccerContract');

contract('SoccerContract', async (accounts) => {
    let instance;

    //Users
    let team1 = accounts[0];
    let team2 = accounts[1];
    let playerAccount = accounts[2];

    before(async () =>{
        instance = await SoccerContract.new();
    })
    
    describe('Team', () => {
        it('should add a new team', async () => {
            
          await instance.addTeam("Galatasaray","Fatih Terim", {
                from: team1
            });
          const event= await instance.getPastEvents('TeamAddition',{_from: team1, _name: 'Galatasaray'});
          let code = event[0].returnValues._code;
        
          const team = await instance.getTeam(code);
          assert.equal(team.name,'Galatasaray','Team name should be Galatasaray') 
         })

         it('should release the player', async () => {
            
            let player = ({
                firstName: 'Wesley',
                lastName: 'Sneijder',
                salary: 123,
                salaryCurrency: "euro"
            });
            let date = ({
                day: 1,
                month: 3,
                year: 2020,
                valid: true
            });
            const event= await instance.getPastEvents('TeamAddition',{_from: team1, _name: 'Galatasaray'});
            let code = event[0].returnValues._code;

            await instance.addPlayer(player,code,date, {
                from: playerAccount
            }); 

            const event_pl= await instance.getPastEvents('PlayerAddition',{_from: playerAccount});
            let code_pl = event_pl[0].returnValues._playerCode;  
            let license_code = event_pl[0].returnValues._licenseCode; 

            await instance.releasePlayer(code,code_pl,license_code);
            const released_player = await instance.getPlayer(code_pl);
            assert.equal(released_player.salary,0,'Player should be released') 
           })
    })

    describe('Player', () => {
        it('should add a new player', async () => {
            
            await instance.addTeam("Galatasaray","Fatih Terim", {
                from: team1
            });
          const event= await instance.getPastEvents('TeamAddition',{_from: team1, _name: 'Galatasaray'});
          let code = event[0].returnValues._code;

            let player = ({
                firstName: 'Wesley',
                lastName: 'Sneijder',
                salary: 123,
                salaryCurrency: "euro"
            });
            let date = ({
                day: 1,
                month: 3,
                year: 2020,
                valid: true
            });

            await instance.addPlayer(player,code,date, {
                from: playerAccount
            });

            const event_pl= await instance.getPastEvents('PlayerAddition',{_from: playerAccount});
            let code_pl = event_pl[0].returnValues._playerCode;
           
            const added_player = await instance.getPlayer(code_pl);
            assert.equal(added_player.firstName,'Wesley','First name should be Wesley') 
         })
         it('should transfer the player', async () => {
            const event_pl= await instance.getPastEvents('PlayerAddition',{_from: playerAccount});
            let code_pl = event_pl[0].returnValues._playerCode;  
            let license_code = event_pl[0].returnValues._licenseCode; 
            
            await instance.addTeam("Galatasaray","Fatih Terim", {
                from: team1
            });

            const event= await instance.getPastEvents('TeamAddition',{_from: team1, _name: 'Galatasaray'});
        
            let code_team = event[0].returnValues._code;


            await instance.addTeam("Barcelona","Guardiola", {
                from: team2
            });
          const event_team2= await instance.getPastEvents('TeamAddition',{_from: team2, _name: 'Barcelona'});
          let code_team2 = event_team2[0].returnValues._code;
          
          let date = ({
            day: 1,
            month: 3,
            year: 2020,
            valid: true
        });
          await instance.transferPlayer(code_pl,code_team,code_team2,1000,date,date,license_code);
        })

         it('should increase the salary of the player', async () => {
            await instance.addTeam("Galatasaray","Fatih Terim", {
                from: team1
            });

            const event= await instance.getPastEvents('TeamAddition',{_from: team1, _name: 'Galatasaray'});
        
            let code_team = event[0].returnValues._code;

            let player = ({
                firstName: 'Wesley',
                lastName: 'Sneijder',
                salary: 123,
                salaryCurrency: "euro"
            });
            
            let date = ({
                day: 1,
                month: 3,
                year: 2020,
                valid: true
            });

            await instance.addPlayer(player,code_team,date, {
                from: playerAccount
            });

            const event_pl= await instance.getPastEvents('PlayerAddition',{_from: playerAccount});
          
            let code_pl = event_pl[0].returnValues._playerCode;  
              
            await instance.increasePlayerSalary(code_pl,17);
            
            const added_player = await instance.getPlayer(code_pl);
            assert.equal(added_player.salary,140,'Salary should be 140') 

         })
        

         it('should sign new contract', async () => {
            await instance.addTeam("Galatasaray","Fatih Terim", {
                from: team1
            });
            
            const event= await instance.getPastEvents('TeamAddition',{_from: team1, _name: 'Galatasaray'});
            let code = event[0].returnValues._code;
            
            let player = ({
                firstName: 'Wesley',
                lastName: 'Sneijder',
                salary: 123,
                salaryCurrency: "euro"
            });
            let date = ({
                day: 1,
                month: 3,
                year: 2020,
                valid: true
            });

            await instance.addPlayer(player,code,date, {
                from: playerAccount
            });

            
            
            const event_pl= await instance.getPastEvents('PlayerAddition',{_from: playerAccount});
            let code_pl = event_pl[0].returnValues._playerCode;    
            let license_code = event_pl[0].returnValues._licenseCode; 

            await instance.releasePlayer(code,code_pl,license_code);
            const released_player = await instance.getPlayer(code_pl);
            
            await instance.addTeam("Barcelona","Guardiola", {
                from: team2
            });

            const event_team2= await instance.getPastEvents('TeamAddition',{_from: team2, _name: 'Barcelona'});
            let code_team2 = event_team2[0].returnValues._code;
          
            await instance.signContract(license_code,code_pl,1500,code_team2,date)
         })
        

    })
})