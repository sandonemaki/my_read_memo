document.addEventListener('DOMContentLoaded', function() {
  // モーダル
  // Open the modal
  function openModal() {
    const modal = document.querySelector('.ModalWrapper');
    const overlay = document.querySelector('.ModalOverlay');
    modal.classList.add('show');
    overlay.classList.add('show');
  }

  // Close the modal
  function closeModal() {
    const modal = document.querySelector('.ModalWrapper');
    const overlay = document.querySelector('.ModalOverlay');
    modal.classList.remove('show');
    overlay.classList.remove('show');
  }
  console.log("dddd")
  document.querySelector('#open-totalpage-modal').addEventListener('click', function() {
    console.log('Button clicked!'); // デバッグメッセージ
    openModal();
  });
  

  // Attach event listener to the close button
  document.querySelector('.ModalCloseButton').addEventListener('click', closeModal);
});