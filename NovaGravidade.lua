require "torch"
local img = require "image"
local tools = require "Documentos/guto_backup/guto/lua/programas/modulos/Ferramentas"
local dbug = require "Documentos/guto_backup/guto/lua/programas/modulos/print_tabela_otimizado"


function esfera(posicao, diametro, atracao, cor)
  return {

    cor = cor;

    posicao = posicao;
    diametro = diametro;

    atracao = atracao;

    Xc = 0;
    Yc = 0;

    atualizar = function(self, OutrasEsferas)
      for esfera in ipairs(OutrasEsferas) do

        if self.posicao[2] < OutrasEsferas[esfera][1] then
          self.Xc = self.Xc + self.atracao
        elseif self.posicao[2] > OutrasEsferas[esfera][1] then
          self.Xc = self.Xc - self.atracao
        end

        if self.posicao[1] < OutrasEsferas[esfera][2] then
          self.Yc = self.Xc + self.atracao
        elseif self.posicao[1] > OutrasEsferas[esfera][2] then
          self.Yc = self.Yc - self.atracao
        end

        self.posicao[2] = self.posicao[2] + self.Xc
        self.posicao[1] = self.posicao[1] + self.Yc
      end

      return self.posicao[2], self.posicao[1], self.diametro, self.cor
    end
  }
end

imagem = torch.DoubleTensor(3,500,500)

imagem:fill(1.0)
imagem[1][500][500] = 254/255


img_model = torch.totable(imagem)

window = img.display(imagem)

esferas = {esfera({2,2},5, 3, {0, 0, 1}),esfera({255,255},5, 1, {0, 1, 0}), esfera({2,2},5, 1, {1, 0, 0})}

dados = {}
while true do
  imagem:fill(1.0)
  imagem[1][500][500] = 254/255

  img_model = torch.totable(imagem)

  for objeto in ipairs(esferas) do

    dados[objeto] = {esferas[objeto]:atualizar(dados)}

  end


  for dado in ipairs(dados) do
    img_model = tools.TorchImageCircle(img_model, dados[dado][3], {dados[dado][1], dados[dado][2]}, dados[dado][4], true)
  end

  imagem = torch.DoubleTensor(img_model)
  window = image.display{image=imagem, win=window}

end
