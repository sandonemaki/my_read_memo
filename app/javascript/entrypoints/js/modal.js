document.addEventListener('DOMContentLoaded', function () {
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

  const openTotalpageModalList = document.querySelectorAll('.open-totalpage-modal-js');
  if (openTotalpageModalList.length > 0) {
    openTotalpageModalList.forEach((element) => {
      element.addEventListener('click', function () {
        openModal();
      });
    });
  }

  // Attach event listener to the close button
  const modalCloseButton = document.querySelector('.ModalCloseButton');
  if (modalCloseButton) {
    modalCloseButton.addEventListener('click', closeModal);
  }
  const modal = document.querySelector('.ModalWrapper');
  if (modal !== null) {
    modal.addEventListener('click', (event) => {
      if (event.target.closest('.ModalContent') === null) {
        closeModal();
      }
    });
  }
});
