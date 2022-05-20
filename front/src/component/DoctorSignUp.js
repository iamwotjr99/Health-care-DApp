import Web3 from 'web3';
import { Form, Button } from 'react-bootstrap';
import { useState, useEffect } from 'react';
import { HEALTH_CARE_ABI, CONTRACT_ADDRESS} from '../abi/HealthCareABI';
import Header from './Header';
function DoctorSignUp() {
    const [doctorData, setDoctorData] = useState({
        docAddr: "",
        hospital: "",
    });

    const [contract, setContract] = useState();

    useEffect(() => {
        async function init() {
            const web3 = new Web3(Web3.givenProvider || 'http://127.0.0.1:7545');

            const contract = new web3.eth.Contract(HEALTH_CARE_ABI, CONTRACT_ADDRESS);
            setContract(contract);

            const account = await web3.eth.requestAccounts();
            console.log("account: ", account);
            setDoctorData({
                ...doctorData,
                docAddr: account[0],
            })
        }
        init();
    }, [])

    const changeHandler = (e) => {
        setDoctorData({
          ...doctorData,
          [e.target.name]: e.target.value,
        })
        console.log(doctorData);
    }

    const signUpHandler = async () => {
        await contract.methods.addDoctor(doctorData.docAddr, doctorData.hospital).send({
            from: doctorData.docAddr
        }).then((error, result) => {
            console.log(result);
        });
    }

    return (
        <div className='doctor_signup_container'>
            <Header />
            <div className='doctor_signup'>
                <Form>
                    <Form.Group className='mb-3' controlId="doctor_address">
                        <Form.Label>Your address</Form.Label>
                        <Form.Control type="text" name="docAddr" value={doctorData.docAddr} onChange={changeHandler}/>
                    </Form.Group>

                    <Form.Group className='mb-3' controlId="hospital_name">
                        <Form.Label>Your hospital name</Form.Label>
                        <Form.Control type="text" name="hospital" value={doctorData.hospital} onChange={changeHandler}/>
                    </Form.Group>
                    <Button onClick={signUpHandler}>Sign Up</Button>
                </Form>
            </div>
        </div>
    )
}

export default DoctorSignUp