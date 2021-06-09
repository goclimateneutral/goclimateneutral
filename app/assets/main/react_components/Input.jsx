import React, { Component } from 'react';

export default class Input extends Component {
  render() {
    const { className, value, onChange, placeholder } = this.props;

    return(
      <input type="text" 
        className={`input ${className !== undefined ? className : ''}`} 
        value={value} 
        onChange={onChange}
        placeholder={placeholder}
      />
    );
  }
}
