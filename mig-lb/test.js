(async () => {

  while (true) {
    const res = await fetch('[LOAD_BALANCER_IP]');
    const text = await res.text();

    console.log(text);
  }
})();