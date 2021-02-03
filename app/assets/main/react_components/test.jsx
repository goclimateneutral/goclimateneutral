import React, { Component } from 'react';

export default class Test extends Component {
  constructor(props) {
    super(props);
    this.state = { liked: false };
  }

  render() {
    if (this.state.liked) {
      return (
        <span class="text-blue-accent">You liked this!!!!</span>
      );
    }

    return(
      <button onClick={() => this.setState({ liked: true })}>
        LOLOLOL
      </button>
    );
  }
}
