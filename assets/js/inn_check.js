let InnCheck = {

    init(socket) {
        let channel = socket.channel('inn_check:lobby', {})
        channel.join()
            .receive("ok", resp => { console.log("Joined successfully", resp) })
            .receive("error", resp => { console.log("Unable to join", resp) })
        this.listenInnEvents(channel)
    },

    listenInnEvents(channel) {
        
        document.getElementById("inn_form").addEventListener('submit', function(e) {
            e.preventDefault()

            let inn = document.getElementById("history_inn").value

            channel.push("check_inn", {inn: inn, status: status})

            document.getElementById("history_inn").value = ""
        })


        channel.on("check_inn", payload => {
            if (payload.error === undefined) {
                document.getElementById("errs").innerHTML = ""
                let history_box = document.querySelector("#hid")
                let historyBlock = document.createElement("tr")
                if (payload.status === "некорректен") { status = `<b style="color:#e36749;">${payload.status}</b>` } else { status = `<b style="color:#5fc97b;">${payload.status}</b>` }
                historyBlock.insertAdjacentHTML('afterbegin', `<td>${payload.inserted_at}</td> <td><b>${payload.inn}</b></td> <td>${status}</td>`)
                history_box.prepend(historyBlock)
            } else {
                document.getElementById('errs').innerHTML = `<div class="alert alert-danger" role="alert"><b>${payload.error}</b></div>`;
            }
        })
    }

}

export default InnCheck