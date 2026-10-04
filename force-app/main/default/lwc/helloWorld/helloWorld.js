import { LightningElement, track} from 'lwc';

export default class HelloWorld extends LightningElement {
    myName = 'Ravi Ranjan'
    details =  {
        name: 'Ravi Ranjan',
        age: 30,
        location: 'India'
    }
    @track info =  {
        name: 'John Doe',
        age: 30,
        location: 'USA'
    }
    handleChange(event){
        this.details = { ...this.details, location: event.target.value };
    }
    handletrackChange(event){
        this.info.location = event.target.value;
    }
    // getter example
    users = ['John', 'Jacob', 'Jace'];
    num1 = 10
    num2 = 20
    get firstUser(){
        return this.users[0].toUpperCase();
    }
    get multiplicationValue(){
        return this.num1*this.num2;
    }
}